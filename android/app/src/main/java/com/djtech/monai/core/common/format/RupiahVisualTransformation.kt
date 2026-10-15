package com.djtech.monai.core.common.format

import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.input.OffsetMapping
import androidx.compose.ui.text.input.TransformedText
import androidx.compose.ui.text.input.VisualTransformation

private const val PREFIX = "Rp "

/**
 * Shows a field holding plain digits (`1250000`) as `Rp 1.250.000`. Formatting only on screen keeps
 * the caret where the user typed; formatting the field's value moves it into the prefix.
 */
object RupiahVisualTransformation : VisualTransformation {

    override fun filter(text: AnnotatedString): TransformedText {
        val digits = text.text
        if (digits.isEmpty()) return TransformedText(text, OffsetMapping.Identity)
        val shown = PREFIX + digits.reversed().chunked(3).joinToString(".").reversed()
        val mapping = object : OffsetMapping {
            // A dot sits before digit k when the digits from k on are a multiple of three.
            override fun originalToTransformed(offset: Int): Int =
                PREFIX.length + offset + (1 until offset).count { (digits.length - it) % 3 == 0 }

            override fun transformedToOriginal(offset: Int): Int =
                shown.take(offset).drop(PREFIX.length).count(Char::isDigit)
        }
        return TransformedText(AnnotatedString(shown), mapping)
    }
}
