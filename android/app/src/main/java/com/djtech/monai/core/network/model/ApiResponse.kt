package com.djtech.monai.core.network.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonObject

/** Success envelope of every API response. `data` is null for deletes. */
@Serializable
data class ApiResponse<T>(
    val success: Boolean,
    val message: String,
    val data: T,
)

/** Success envelope of an offset-paginated list. */
@Serializable
data class PagedResponse<T>(
    val success: Boolean,
    val message: String,
    val data: List<T>,
    val meta: PageMeta,
)

/** Success envelope of a cursor-paginated list. */
@Serializable
data class CursorResponse<T>(
    val success: Boolean,
    val message: String,
    val data: List<T>,
    val meta: CursorMeta,
)

@Serializable
data class PageMeta(
    val page: Int,
    @SerialName("per_page") val perPage: Int,
    val total: Long,
    @SerialName("total_pages") val totalPages: Int,
)

@Serializable
data class CursorMeta(
    @SerialName("next_cursor") val nextCursor: String? = null,
    @SerialName("has_more") val hasMore: Boolean,
    val limit: Int,
)

/** Error envelope: `{success: false, message, data: null, error: {code, fields}}`. */
@Serializable
internal data class ErrorResponse(
    val message: String = "",
    val error: ErrorDetail,
)

@Serializable
internal data class ErrorDetail(
    val code: String,
    val fields: List<FieldErrorDto> = emptyList(),
)

@Serializable
internal data class FieldErrorDto(
    val field: String,
    val code: String,
    val message: String,
    val params: JsonObject? = null,
)
