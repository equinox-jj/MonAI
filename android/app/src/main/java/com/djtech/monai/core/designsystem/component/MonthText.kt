package com.djtech.monai.core.designsystem.component

import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.platform.LocalConfiguration
import java.time.YearMonth
import java.time.format.DateTimeFormatter
import java.time.format.TextStyle
import java.util.Locale

// Month names in the app's locale, for screens of several features.

@Composable
@ReadOnlyComposable
fun currentLocale(): Locale = LocalConfiguration.current.locales[0]

/** `October`. */
@Composable
@ReadOnlyComposable
fun YearMonth.monthName(): String = month.getDisplayName(TextStyle.FULL_STANDALONE, currentLocale())

/** `Oct`. */
@Composable
@ReadOnlyComposable
fun YearMonth.shortMonthName(): String = month.getDisplayName(TextStyle.SHORT_STANDALONE, currentLocale())

/** `October 2026`. */
@Composable
@ReadOnlyComposable
fun YearMonth.monthYearName(): String = format(DateTimeFormatter.ofPattern("LLLL yyyy", currentLocale()))
