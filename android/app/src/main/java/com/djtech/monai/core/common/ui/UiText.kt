package com.djtech.monai.core.common.ui

import android.content.Context
import androidx.annotation.PluralsRes
import androidx.annotation.StringRes
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource

/** Text a ViewModel can emit without a Context: either a string resource or text from the server. */
sealed interface UiText {

    data class Dynamic(val value: String) : UiText

    class Resource(@StringRes val id: Int, vararg val args: Any) : UiText {
        // Value equality, so states holding UiText compare (and skip recomposition) by content.
        override fun equals(other: Any?): Boolean =
            other is Resource && id == other.id && args.contentEquals(other.args)

        override fun hashCode(): Int = 31 * id + args.contentHashCode()

        override fun toString(): String = "Resource(id=$id, args=${args.contentToString()})"
    }

    /** A plurals resource; [count] picks the form and [args] fill it (usually the count again). */
    class Plural(@PluralsRes val id: Int, val count: Int, vararg val args: Any) : UiText {
        override fun equals(other: Any?): Boolean =
            other is Plural && id == other.id && count == other.count && args.contentEquals(other.args)

        override fun hashCode(): Int = 31 * (31 * id + count) + args.contentHashCode()

        override fun toString(): String = "Plural(id=$id, count=$count, args=${args.contentToString()})"
    }

    fun asString(context: Context): String = when (this) {
        is Dynamic -> value
        is Resource -> context.getString(id, *args)
        is Plural -> context.resources.getQuantityString(id, count, *args)
    }

    @Composable
    fun asString(): String = when (this) {
        is Dynamic -> value
        is Resource -> stringResource(id, *args)
        is Plural -> pluralStringResource(id, count, *args)
    }
}
