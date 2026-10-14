package com.djtech.monai.feature.quickadd.domain.parser

/**
 * Splits a phrase with several purchases ("kopi 25rb sama parkir 5rb kmrn") into one part per
 * amount. A part without an amount ("kmrn") stays with the part before it, so a phrase with one
 * amount is never split. Without a separator, a part with several clear amounts
 * ("makan 35rb bensin 20rb") is cut after each one.
 */
object PhraseSplitter {

    private val SEPARATOR = Regex("""\s+(?:sama|dan|terus|trus|plus|and|&)\s+|\s*[;+]\s*|,\s+|\n+""")

    fun split(text: String, amountsIn: (String) -> List<AmountMatch>): List<String> {
        val hasAmount = { part: String -> amountsIn(part).isNotEmpty() }
        val parts = text.split(SEPARATOR).map(String::trim).filter(String::isNotEmpty)
        val merged = if (parts.count(hasAmount) < 2) listOf(text.trim()) else merge(parts, hasAmount)
        return merged.flatMap { cutAfterClearAmounts(it, amountsIn(it)) }
    }

    private fun merge(parts: List<String>, hasAmount: (String) -> Boolean): List<String> {
        val merged = mutableListOf<String>()
        for (part in parts) {
            if (hasAmount(part) || merged.isEmpty()) merged += part else merged[merged.lastIndex] += " $part"
        }
        // A leading part without an amount ("kemarin, kopi 25rb, roti 10rb") joins the next one.
        if (!hasAmount(merged.first()) && merged.size > 1) {
            merged[1] = merged.first() + " " + merged[1]
            merged.removeAt(0)
        }
        return merged
    }

    // Unclear numbers ("beli 2 kopi 50rb") never cut; the words after the last amount stay with it.
    private fun cutAfterClearAmounts(part: String, amounts: List<AmountMatch>): List<String> {
        val cuts = amounts.filter(AmountMatch::isClear).dropLast(1).map { it.range.last + 1 }
        if (cuts.isEmpty()) return listOf(part)
        return (listOf(0) + cuts).zip(cuts + part.length) { from, to -> part.substring(from, to).trim() }
    }
}
