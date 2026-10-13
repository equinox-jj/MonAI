package com.djtech.monai.feature.quickadd.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ParseTransactionRequestDto(
    @SerialName("text") val text: String,
    /** The user's local date, `YYYY-MM-DD`, for relative dates like "kemarin". */
    @SerialName("today") val today: String,
    @SerialName("timezone") val timezone: String,
)
