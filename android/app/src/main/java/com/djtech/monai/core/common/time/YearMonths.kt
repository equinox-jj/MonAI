package com.djtech.monai.core.common.time

import java.time.LocalDate
import java.time.YearMonth
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException

private val API_MONTH: DateTimeFormatter = DateTimeFormatter.ofPattern("uuuu-MM")

/** The API's `YYYY-MM` month, e.g. `2026-03`. */
fun YearMonth.toApiString(): String = format(API_MONTH)

fun String.toYearMonthOrNull(): YearMonth? = try {
    YearMonth.parse(this, API_MONTH)
} catch (_: DateTimeParseException) {
    null
}

/** Transaction dates may not be later than today in the user's zone. */
fun LocalDate.isFutureIn(clock: AppClock): Boolean = isAfter(clock.today())
