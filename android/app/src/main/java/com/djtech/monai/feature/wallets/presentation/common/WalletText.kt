package com.djtech.monai.feature.wallets.presentation.common

import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.platform.LocalConfiguration
import java.time.LocalDate
import java.time.YearMonth
import java.time.format.DateTimeFormatter
import java.time.format.TextStyle
import java.util.Locale

@Composable
@ReadOnlyComposable
internal fun currentLocale(): Locale = LocalConfiguration.current.locales[0]

/** `October`. */
@Composable
@ReadOnlyComposable
internal fun YearMonth.monthName(): String = month.getDisplayName(TextStyle.FULL_STANDALONE, currentLocale())

/** `9 Oct`. */
@Composable
@ReadOnlyComposable
internal fun LocalDate.shortDate(): String = format(DateTimeFormatter.ofPattern("d MMM", currentLocale()))
