package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.AuthResult

// Local field errors fail the same way as the server's, so screens handle one error shape.
internal inline fun <T> List<AuthFieldError>.failOr(call: () -> AuthResult<T>): AuthResult<T> =
    if (isEmpty()) call() else Outcome.Failure(AuthError.InvalidFields(this))
