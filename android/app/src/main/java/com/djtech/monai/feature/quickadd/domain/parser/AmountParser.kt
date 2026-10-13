package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.common.format.MAX_AMOUNT
import java.math.BigDecimal
import java.math.RoundingMode

/** An amount found in lowercase quick-add text, with the characters it covers. */
data class AmountMatch(val amount: Long, val range: IntRange, val confidence: Double)

/** Finds rupiah amounts such as `35rb`, `35.000`, `1,5jt` or `goceng`. */
object AmountParser {

    // Group 1: digits split into groups of three (`2.500.000`); group 2: plain or decimal (`1,5`).
    private val NUMBER = Regex(
        """(?<![\w.,])(?:rp\.?\s*)?(?:(\d{1,3}(?:[.,]\d{3})+)|(\d+(?:[.,]\d+)?))\s*(ribu|rebu|rb|k|jt|juta)?(?!\w)""",
    )

    private val SLANG = Regex("""(?<!\w)(gopek|seceng|ceceng|goceng|ceban|seribu|sejuta)(?!\w)""")

    private val SLANG_VALUES = mapOf(
        "gopek" to 500L,
        "seceng" to 1_000L,
        "ceceng" to 1_000L,
        "seribu" to 1_000L,
        "goceng" to 5_000L,
        "ceban" to 10_000L,
        "sejuta" to 1_000_000L,
    )

    private const val EXPLICIT = 0.95
    private const val PLAIN = 0.9
    private const val BARE_SMALL = 0.4
    private const val ODD_DECIMAL = 0.3

    fun findAll(text: String): List<AmountMatch> {
        val numbers = NUMBER.findAll(text).mapNotNull { match ->
            val (grouped, plain, suffix) = match.destructured
            val multiplier = when (suffix) {
                "" -> 1L
                "jt", "juta" -> 1_000_000L
                else -> 1_000L
            }
            val (value, confidence) = when {
                grouped.isNotEmpty() -> grouped.filter(Char::isDigit).toBigDecimal() to EXPLICIT
                suffix.isNotEmpty() -> plain.replace(',', '.').toBigDecimal() to EXPLICIT
                plain.any { it == '.' || it == ',' } -> plain.replace(',', '.').toBigDecimal() to ODD_DECIMAL
                else -> plain.toBigDecimal().let { it to if (it >= BigDecimal(1_000)) PLAIN else BARE_SMALL }
            }
            val amount = value.multiply(BigDecimal(multiplier)).setScale(0, RoundingMode.HALF_UP)
            amount.toLongInRange()?.let { AmountMatch(it, match.range, confidence) }
        }
        val slang = SLANG.findAll(text).map { AmountMatch(SLANG_VALUES.getValue(it.value), it.range, PLAIN) }
        return (numbers + slang).sortedBy { it.range.first }.toList()
    }

    private fun BigDecimal.toLongInRange(): Long? =
        takeIf { it > BigDecimal.ZERO && it <= BigDecimal(MAX_AMOUNT) }?.toLong()
}
