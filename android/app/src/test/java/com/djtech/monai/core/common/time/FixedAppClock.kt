package com.djtech.monai.core.common.time

import java.time.Instant
import java.time.ZoneId

class FixedAppClock(
    private val instant: Instant,
    private val zone: ZoneId = ZoneId.of("Asia/Jakarta"),
) : AppClock {
    override fun now(): Instant = instant
    override fun zone(): ZoneId = zone
}
