package com.djtech.monai.feature.profile.presentation.editprofile.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.profile.domain.model.IndonesianTimezones
import com.djtech.monai.feature.profile.domain.model.NameIssue
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.usecase.UpdateProfileUseCase
import com.djtech.monai.feature.profile.presentation.editprofile.model.TimezoneOption
import java.time.Instant
import java.time.ZoneId
import java.time.ZoneOffset
import kotlin.math.abs

private val INDONESIAN_NAMES = mapOf(
    "Asia/Jakarta" to R.string.profile_timezone_wib,
    "Asia/Makassar" to R.string.profile_timezone_wita,
    "Asia/Jayapura" to R.string.profile_timezone_wit,
)

/** `Asia/Jakarta` → a row reading "Jakarta" with its offset at [now]. */
fun timezoneOption(id: String, now: Instant): TimezoneOption = TimezoneOption(
    id = id,
    label = id.substringAfterLast('/').replace('_', ' '),
    offset = ZoneId.of(id).rules.getOffset(now).toUtcLabel(),
    indonesianName = INDONESIAN_NAMES[id],
)

/**
 * Indonesia's zones first, then every other zone whose name contains [query] (spaces match the
 * underscores of `Asia/Ho_Chi_Minh`). A non-blank query searches Indonesia's zones too.
 */
fun timezoneOptions(
    all: List<String>,
    query: String,
    now: Instant,
): Pair<List<TimezoneOption>, List<TimezoneOption>> {
    val needle = query.trim().replace(' ', '_')
    fun matches(id: String) = needle.isEmpty() || id.contains(needle, ignoreCase = true)
    val indonesian = IndonesianTimezones.filter(::matches).map { timezoneOption(it, now) }
    val others = all.filter { it !in IndonesianTimezones && matches(it) }.map { timezoneOption(it, now) }
    return indonesian to others
}

/** `+07:00` → `UTC+7`, `+05:30` → `UTC+5:30`, `Z` → `UTC`. */
private fun ZoneOffset.toUtcLabel(): String {
    if (totalSeconds == 0) return "UTC"
    val sign = if (totalSeconds < 0) "−" else "+"
    val minutes = abs(totalSeconds) / 60
    val hours = minutes / 60
    val rest = minutes % 60
    return "UTC$sign$hours" + if (rest > 0) ":" + rest.toString().padStart(2, '0') else ""
}

fun ProfileError.message(): UiText = when (this) {
    ProfileError.Network -> UiText.Resource(R.string.profile_error_network)
    is ProfileError.InvalidName -> issue.message()
    ProfileError.InvalidTimezone -> UiText.Resource(R.string.profile_error_timezone)
    ProfileError.PasswordRequired -> UiText.Resource(R.string.profile_error_password_required)
    ProfileError.WrongPassword -> UiText.Resource(R.string.profile_error_wrong_password)
    ProfileError.LastAdmin -> UiText.Resource(R.string.profile_error_last_admin)
    is ProfileError.RateLimited -> retryAfter?.inWholeMinutes?.takeIf { it > 0 }?.let {
        UiText.Plural(R.plurals.profile_error_rate_limited, it.toInt(), it.toInt())
    } ?: UiText.Resource(R.string.profile_error_rate_limited_soon)

    ProfileError.PhotoTooLarge -> UiText.Resource(R.string.profile_error_photo_too_large)
    ProfileError.PhotoUnsupported -> UiText.Resource(R.string.profile_error_photo_unsupported)
    ProfileError.Unexpected -> UiText.Resource(R.string.profile_error_unexpected)
}

fun NameIssue.message(): UiText = when (this) {
    NameIssue.REQUIRED -> UiText.Resource(R.string.profile_error_name_required)
    NameIssue.TOO_LONG -> UiText.Resource(R.string.profile_error_name_too_long, UpdateProfileUseCase.MAX_NAME_LENGTH)
    NameIssue.INVALID -> UiText.Resource(R.string.profile_error_name_invalid)
}
