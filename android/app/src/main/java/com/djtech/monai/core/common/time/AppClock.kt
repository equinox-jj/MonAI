package com.djtech.monai.core.common.time

import java.time.Clock
import java.time.Instant
import java.time.LocalDate
import java.time.LocalTime
import java.time.YearMonth
import java.time.ZoneId
import java.time.ZoneOffset
import javax.inject.Inject

/** The current time and the zone that business dates ("today", the month) are read in. */
interface AppClock {
    fun now(): Instant
    fun zone(): ZoneId

    // Not LocalDate.ofInstant: that is API 34+ and minSdk is 26.
    fun today(): LocalDate = now().atZone(zone()).toLocalDate()
    fun currentMonth(): YearMonth = YearMonth.from(today())

    /** The wall-clock time in [zone], e.g. for a time-of-day greeting. */
    fun localTime(): LocalTime = now().atZone(zone()).toLocalTime()
}

private val JAKARTA: ZoneId = ZoneId.of("Asia/Jakarta")

/**
 * Uses the device zone, read on every call so a zone change applies at once.
 * A device that reports UTC usually has no zone set, so Asia/Jakarta is used instead.
 */
class SystemAppClock internal constructor(
    private val clock: Clock,
    private val systemZone: () -> ZoneId,
) : AppClock {

    @Inject
    constructor() : this(Clock.systemUTC(), ZoneId::systemDefault)

    override fun now(): Instant = clock.instant()

    override fun zone(): ZoneId {
        val zone = systemZone()
        return if (zone.normalized() == ZoneOffset.UTC) JAKARTA else zone
    }
}
