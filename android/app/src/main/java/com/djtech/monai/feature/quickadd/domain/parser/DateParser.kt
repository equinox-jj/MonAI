package com.djtech.monai.feature.quickadd.domain.parser

import java.time.DayOfWeek
import java.time.LocalDate
import java.time.YearMonth
import java.time.temporal.TemporalAdjusters

/** A date found in lowercase quick-add text, with the characters it covers. */
data class DateMatch(val date: LocalDate, val range: IntRange, val confidence: Double)

/** Finds relative and partial dates (`kemarin`, `senin lalu`, `tgl 5`), never later than today. */
object DateParser {

    private const val SURE = 0.95
    private const val LIKELY = 0.85

    private val WEEKDAYS = mapOf(
        "senin" to DayOfWeek.MONDAY,
        "selasa" to DayOfWeek.TUESDAY,
        "rabu" to DayOfWeek.WEDNESDAY,
        "kamis" to DayOfWeek.THURSDAY,
        "jumat" to DayOfWeek.FRIDAY,
        "jum'at" to DayOfWeek.FRIDAY,
        "sabtu" to DayOfWeek.SATURDAY,
        "minggu" to DayOfWeek.SUNDAY,
        "ahad" to DayOfWeek.SUNDAY,
        "monday" to DayOfWeek.MONDAY,
        "tuesday" to DayOfWeek.TUESDAY,
        "wednesday" to DayOfWeek.WEDNESDAY,
        "thursday" to DayOfWeek.THURSDAY,
        "friday" to DayOfWeek.FRIDAY,
        "saturday" to DayOfWeek.SATURDAY,
        "sunday" to DayOfWeek.SUNDAY,
    )

    private val MONTHS = listOf(
        listOf("jan", "januari", "january"),
        listOf("feb", "februari", "february"),
        listOf("mar", "maret", "march"),
        listOf("apr", "april"),
        listOf("mei", "may"),
        listOf("jun", "juni", "june"),
        listOf("jul", "juli", "july"),
        listOf("agu", "agt", "agustus", "aug", "august"),
        listOf("sep", "sept", "september"),
        listOf("okt", "oktober", "oct", "october"),
        listOf("nov", "november"),
        listOf("des", "desember", "dec", "december"),
    )
    private val MONTH_NUMBERS = MONTHS.flatMapIndexed { index, names -> names.map { it to index + 1 } }.toMap()

    private val weekdayNames = WEEKDAYS.keys.joinToString("|")
    private val monthNames = MONTH_NUMBERS.keys.sortedByDescending { it.length }.joinToString("|")

    /** Tried in order; the first that yields a valid date wins. */
    private val rules: List<Pair<Regex, (MatchResult, LocalDate) -> Pair<LocalDate, Double>?>> = listOf(
        word("kemarin lusa|kmrn lusa") to { _, today -> today.minusDays(2) to SURE },
        word("hari ini|today|barusan|tadi(?: pagi| siang| sore| malam)?|(?:pagi|siang|sore|malam) ini|tonight") to
            { _, today -> today to SURE },
        word("kemarin|kemaren|kmrn|kmarin|yesterday|semalam") to { _, today -> today.minusDays(1) to SURE },
        word("""(\d{1,2}) (?:hari|hr) (?:yang |yg )?lalu|(\d{1,2}) days? ago""") to { match, today ->
            val days = match.groupValues[1].ifEmpty { match.groupValues[2] }.toLong()
            today.minusDays(days) to SURE
        },
        word("""(?:hari )?($weekdayNames)(?: (lalu|kemarin|kmrn))?|(last) ($weekdayNames)""") to { match, today ->
            val (name, qualifier, last, lastName) = match.destructured
            val day = WEEKDAYS.getValue(name.ifEmpty { lastName })
            val beforeToday = qualifier.isNotEmpty() || last.isNotEmpty()
            val adjuster = if (beforeToday) TemporalAdjusters.previous(day) else TemporalAdjusters.previousOrSame(day)
            today.with(adjuster) to LIKELY
        },
        word("""(\d{1,2}) ($monthNames)(?: (\d{4}))?""") to { match, today ->
            val (day, month, year) = match.destructured
            dayOfMonth(today, day.toInt(), MONTH_NUMBERS.getValue(month), year.toIntOrNull())?.let { it to SURE }
        },
        word("""(?:tgl|tanggal|tg)\.? ?(\d{1,2})(?:[/-](\d{1,2}))?""") to { match, today ->
            val (day, month) = match.destructured
            dayOfMonth(today, day.toInt(), month.toIntOrNull(), year = null)?.let { it to SURE }
        },
        word("""(\d{1,2})/(\d{1,2})(?:/(\d{4}))?""") to { match, today ->
            val (day, month, year) = match.destructured
            dayOfMonth(today, day.toInt(), month.toInt(), year.toIntOrNull())?.let { it to LIKELY }
        },
    )

    fun find(text: String, today: LocalDate): DateMatch? {
        for ((regex, resolve) in rules) {
            for (match in regex.findAll(text)) {
                val (date, confidence) = resolve(match, today) ?: continue
                if (!date.isAfter(today)) return DateMatch(date, match.range, confidence)
            }
        }
        return null
    }

    /**
     * The latest [day] not after [today]: in [month] (this year, else last year) when given,
     * otherwise this month or the one before. Null for a day the month doesn't have.
     */
    private fun dayOfMonth(today: LocalDate, day: Int, month: Int?, year: Int?): LocalDate? {
        if (month != null && month !in 1..12) return null
        val candidate = when {
            month == null && day <= today.dayOfMonth -> YearMonth.from(today)
            month == null -> YearMonth.from(today).minusMonths(1)
            year != null -> YearMonth.of(year, month)
            YearMonth.of(today.year, month).isAfter(YearMonth.from(today)) -> YearMonth.of(today.year - 1, month)
            else -> YearMonth.of(today.year, month)
        }
        if (!candidate.isValidDay(day)) return null
        val date = candidate.atDay(day)
        // "24 des" said in October means last December.
        return if (date.isAfter(today) && month != null && year == null) date.minusYears(1) else date
    }

    private fun word(pattern: String) = Regex("""(?<![\w'])(?:$pattern)(?![\w'])""")
}
