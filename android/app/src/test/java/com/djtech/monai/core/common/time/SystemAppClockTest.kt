package com.djtech.monai.core.common.time

import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.Clock
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth
import java.time.ZoneId
import java.time.ZoneOffset

class SystemAppClockTest {

    // 2026-10-31 18:30 UTC is already 1 November in Jakarta (UTC+7).
    private val instant = Instant.parse("2026-10-31T18:30:00Z")
    private val fixed = Clock.fixed(instant, ZoneOffset.UTC)

    @Test
    fun `uses the device zone`() {
        val clock = SystemAppClock(fixed) { ZoneId.of("Asia/Makassar") }

        assertEquals(ZoneId.of("Asia/Makassar"), clock.zone())
        assertEquals(instant, clock.now())
    }

    @Test
    fun `falls back to Jakarta when the device reports UTC`() {
        val utcAliases = listOf(
            "UTC",
            "GMT",
            "Etc/UTC",
            "Z",
        )
        for (zone in utcAliases) {
            val clock = SystemAppClock(fixed) { ZoneId.of(zone) }
            assertEquals(zone, ZoneId.of("Asia/Jakarta"), clock.zone())
        }
    }

    @Test
    fun `today and currentMonth follow the zone`() {
        val clock = SystemAppClock(fixed) { ZoneId.of("Asia/Jakarta") }

        assertEquals(LocalDate.of(2026, 11, 1), clock.today())
        assertEquals(YearMonth.of(2026, 11), clock.currentMonth())
    }

    @Test
    fun `reads the device zone on every call`() {
        var zone = ZoneId.of("Asia/Jakarta")
        val clock = SystemAppClock(fixed) { zone }
        zone = ZoneId.of("Asia/Jayapura")

        assertEquals(ZoneId.of("Asia/Jayapura"), clock.zone())
    }
}
