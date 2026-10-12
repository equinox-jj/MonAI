package com.djtech.monai.core.network

import com.djtech.monai.core.common.result.Outcome

/** What [ApiCaller] returns; repositories map the [ApiError] to their own domain error. */
typealias ApiResult<T> = Outcome<T, ApiError>
