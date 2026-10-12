package com.djtech.monai.core.common.format

import kotlin.math.absoluteValue

/** U+2212, the same minus sign the designsystem shows. */
private const val MINUS = "−"

enum class MoneySign { Negative, Positive, None }

/** `35.000`: id-ID dot grouping, no currency. The sign is dropped. */
fun formatThousands(amount: Long): String =
    amount.toString().removePrefix("-").reversed().chunked(3).joinToString(".").reversed()

/** `Rp 35.000`, or `−Rp 120.000` for a negative amount. */
fun formatRupiah(amount: Long): String =
    (if (amount < 0) MINUS else "") + "Rp " + formatThousands(amount)

/**
 * `−Rp 35.000` / `+Rp 8.500.000` / `Rp 500.000`. [sign] comes from the transaction
 * type because amounts are stored positive, so the sign of [amount] is ignored.
 */
fun formatRupiahSigned(amount: Long, sign: MoneySign): String {
    val prefix = when (sign) {
        MoneySign.Negative -> MINUS
        MoneySign.Positive -> "+"
        MoneySign.None -> ""
    }
    return prefix + "Rp " + formatThousands(amount)
}

private val COMPACT_UNITS = listOf(
    1_000_000_000_000L to "T",
    1_000_000_000L to "M",
    1_000_000L to "jt",
    1_000L to "rb",
)

/**
 * `Rp 35 rb`, `Rp 1,5 jt`, `Rp 2 M`. Keeps one decimal, truncated so 999.999
 * reads `999,9 rb` rather than rounding up to `1.000 rb`.
 */
fun formatRupiahCompact(amount: Long): String {
    val sign = if (amount < 0) MINUS else ""
    val abs = amount.absoluteValue
    val (unit, suffix) = COMPACT_UNITS.firstOrNull { abs >= it.first }
        ?: return formatRupiah(amount)
    val whole = abs / unit
    val tenth = (abs % unit) / (unit / 10)
    val number = formatThousands(whole) + if (tenth > 0) ",$tenth" else ""
    return "${sign}Rp $number $suffix"
}
