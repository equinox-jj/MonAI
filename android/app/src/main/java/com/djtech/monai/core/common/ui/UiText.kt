package com.djtech.monai.core.common.ui

import android.content.Context
import androidx.annotation.StringRes
import androidx.compose.runtime.Composable
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

    fun asString(context: Context): String = when (this) {
        is Dynamic -> value
        is Resource -> context.getString(id, *args)
    }

    @Composable
    fun asString(): String = when (this) {
        is Dynamic -> value
        is Resource -> stringResource(id, *args)
    }
}
