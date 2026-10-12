package com.djtech.monai.feature.auth.presentation.common

import androidx.compose.runtime.Composable
import androidx.compose.runtime.Stable
import androidx.compose.runtime.remember
import androidx.compose.ui.focus.FocusRequester
import com.djtech.monai.feature.auth.domain.model.AuthField

/** One [FocusRequester] per form field, so a screen's FocusField effect can move focus to it. */
@Stable
class AuthFieldFocus internal constructor() {
    private val requesters = AuthField.entries.associateWith { FocusRequester() }

    internal fun requester(field: AuthField): FocusRequester = requesters.getValue(field)

    /** Only for fields the current screen shows; an unattached requester throws. */
    fun request(field: AuthField) {
        requesters.getValue(field).requestFocus()
    }
}

@Composable
fun rememberAuthFieldFocus(): AuthFieldFocus = remember { AuthFieldFocus() }
