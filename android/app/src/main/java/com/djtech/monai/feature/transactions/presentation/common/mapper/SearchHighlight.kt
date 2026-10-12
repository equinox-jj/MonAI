package com.djtech.monai.feature.transactions.presentation.common.mapper

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle

private val WORD = Regex("[\\p{L}\\p{N}]+")

/** Whether any word of [query] appears in this text, ignoring case. */
fun String.matchesSearch(query: String): Boolean =
    WORD.findAll(query).any { contains(it.value, ignoreCase = true) }

/** Marks every case-insensitive occurrence of each word of [query]. */
fun String.highlighted(query: String?, mark: Color): AnnotatedString {
    if (query.isNullOrBlank()) return AnnotatedString(this)
    val ranges = WORD.findAll(query).flatMap { word ->
        Regex(Regex.escape(word.value), RegexOption.IGNORE_CASE).findAll(this).map { it.range }
    }.sortedBy { it.first }
    val text = this
    return buildAnnotatedString {
        var cursor = 0
        for (range in ranges) {
            if (range.first < cursor) continue
            append(text, cursor, range.first)
            withStyle(SpanStyle(background = mark, fontWeight = FontWeight.SemiBold)) {
                append(text.substring(range))
            }
            cursor = range.last + 1
        }
        // text.length: a bare `length` here is the builder's.
        append(text, cursor, text.length)
    }
}
