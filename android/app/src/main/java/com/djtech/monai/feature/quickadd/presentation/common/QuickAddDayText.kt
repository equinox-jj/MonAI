package com.djtech.monai.feature.quickadd.presentation.common

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.currentLocale
import java.time.LocalDate
import java.time.format.DateTimeFormatter

/** `Today`, `Yesterday` or `8 Oct`, for chips and draft rows. */
@Composable
internal fun dayText(date: LocalDate, today: LocalDate): String = when (date) {
    today -> stringResource(R.string.quick_add_today)
    today.minusDays(1) -> stringResource(R.string.quick_add_yesterday)
    else -> date.format(DateTimeFormatter.ofPattern("d MMM", currentLocale()))
}
