package com.djtech.monai.core.database

// Uppercase only: FTS treats lowercase "or"/"and" as plain words.
private val FTS_OPERATORS = setOf("AND", "OR", "NOT", "NEAR")

/**
 * Turns free text into an FTS4 MATCH expression that prefix-matches every word, so "kopi ken"
 * finds "Kopi Kenangan". Punctuation is dropped (the unicode61 tokenizer splits on it anyway),
 * which keeps quotes, `*`, `-` and parentheses from being read as query syntax.
 * Returns null when nothing searchable is left.
 */
fun toFtsMatchQuery(raw: String): String? = raw
    .split(Regex("[^\\p{L}\\p{N}]+"))
    .filter { it.isNotEmpty() && it !in FTS_OPERATORS }
    .takeIf { it.isNotEmpty() }
    ?.joinToString(" ") { "$it*" }
