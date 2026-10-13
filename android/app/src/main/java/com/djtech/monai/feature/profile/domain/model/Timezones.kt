package com.djtech.monai.feature.profile.domain.model

import java.time.ZoneId

/** Indonesia's three zones, offered first: WIB, WITA and WIT. */
val IndonesianTimezones: List<String> = listOf("Asia/Jakarta", "Asia/Makassar", "Asia/Jayapura")

/** `Region/City` zones the user can pick, sorted; legacy aliases like `US/Pacific` are left out. */
fun pickableTimezones(): List<String> = ZoneId.getAvailableZoneIds()
    .filter { id -> '/' in id && REGIONS.any { id.startsWith("$it/") } }
    .sorted()

/** Whether [id] is a zone java.time (and so the server's Go tz database) knows. */
fun isKnownTimezone(id: String): Boolean = try {
    ZoneId.of(id)
    true
} catch (_: Exception) {
    false
}

private val REGIONS = listOf(
    "Africa",
    "America",
    "Antarctica",
    "Asia",
    "Atlantic",
    "Australia",
    "Europe",
    "Indian",
    "Pacific",
)
