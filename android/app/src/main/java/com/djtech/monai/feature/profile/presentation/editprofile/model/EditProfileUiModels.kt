package com.djtech.monai.feature.profile.presentation.editprofile.model

import androidx.annotation.StringRes
import androidx.compose.runtime.Immutable
import androidx.compose.ui.graphics.ImageBitmap
import com.djtech.monai.core.media.CropSpec

/** A bottom sheet over Edit profile. */
enum class EditProfileSheet { PhotoSource, Timezone }

/**
 * The full-screen crop of a picked photo.
 *
 * @param preview the photo upright, for drawing; null while it loads.
 * @param spec how the photo sits in the square window; what Done crops.
 */
@Immutable
data class CropState(
    val uri: String,
    val preview: ImageBitmap? = null,
    val spec: CropSpec = CropSpec(),
)

/**
 * A timezone row: [id] is the IANA name sent to the API, [label] its city, [offset] like `UTC+7`.
 * [indonesianName] names Indonesia's three zones (WIB, WITA, WIT).
 */
@Immutable
data class TimezoneOption(
    val id: String,
    val label: String,
    val offset: String,
    @StringRes val indonesianName: Int? = null,
)
