package com.djtech.monai.feature.quickadd.data.dto

import com.djtech.monai.core.network.model.TransactionDraftDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `data` of `POST /ai/parse-transaction`. */
@Serializable
data class ParsedDraftsDto(
    @SerialName("drafts") val drafts: List<TransactionDraftDto>,
)
