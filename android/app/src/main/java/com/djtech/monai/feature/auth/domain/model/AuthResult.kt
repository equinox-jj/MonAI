package com.djtech.monai.feature.auth.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias AuthResult<T> = Outcome<T, AuthError>
