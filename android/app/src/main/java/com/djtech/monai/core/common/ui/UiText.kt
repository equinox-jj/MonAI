package com.djtech.monai.core.common.ui

import android.content.Context
import androidx.annotation.StringRes
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource

/** Text a ViewModel can emit without a Context: either a string resource or text from the server. */
sealed interface UiText {

    data class Dynamic(val value: String) : UiText

    class Resource(@StringRes val id: Int, vararg val args: Any) : UiText

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
