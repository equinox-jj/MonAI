package com.djtech.monai.feature.auth.presentation.common

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAIInlineAlert

/** The banner for a whole-form error. A live region, so TalkBack reads it when it appears. */
@Composable
internal fun AuthFormError(error: UiText?, modifier: Modifier = Modifier) {
    if (error == null) return
    MonAIInlineAlert(
        error.asString(),
        modifier.semantics { liveRegion = LiveRegionMode.Polite },
        tone = MonAIAlertTone.Error,
    )
}

/** A field with an error message is drawn in the error tone. */
internal fun UiText?.fieldTone(): MonAIFieldTone = if (this == null) MonAIFieldTone.Neutral else MonAIFieldTone.Error
