package com.djtech.monai.core.common.format

import java.time.LocalDate
import java.time.YearMonth
import java.time.format.DateTimeFormatter
import java.util.Locale

val IndonesianLocale: Locale = Locale.forLanguageTag("id-ID")

/** `Oktober 2026`: the month switcher title. */
fun formatMonth(month: YearMonth, locale: Locale = IndonesianLocale): String =
    month.format(DateTimeFormatter.ofPattern("LLLL yyyy", locale))

/** `Senin, 5 Okt`: a day group header. "Today"/"Yesterday" labels come from string resources. */
fun formatDayHeader(date: LocalDate, locale: Locale = IndonesianLocale): String =
    date.format(DateTimeFormatter.ofPattern("EEEE, d MMM", locale))
