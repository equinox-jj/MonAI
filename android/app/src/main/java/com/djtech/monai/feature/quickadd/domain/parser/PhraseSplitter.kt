package com.djtech.monai.feature.quickadd.domain.parser

/**
 * Splits a phrase with several purchases ("kopi 25rb sama parkir 5rb kmrn") into one part per
 * amount. A part without an amount ("kmrn") stays with the part before it, so a phrase with one
 * amount is never split.
 */
object PhraseSplitter {

    private val SEPARATOR = Regex("""\s+(?:sama|dan|terus|trus|plus|and|&)\s+|\s*[;+]\s*|,\s+|\n+""")

    fun split(text: String, hasAmount: (String) -> Boolean): List<String> {
        val parts = text.split(SEPARATOR).map(String::trim).filter(String::isNotEmpty)
        if (parts.count(hasAmount) < 2) return listOf(text.trim())
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
}
