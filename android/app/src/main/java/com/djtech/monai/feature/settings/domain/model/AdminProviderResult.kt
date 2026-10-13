package com.djtech.monai.feature.settings.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias AdminProviderResult<T> = Outcome<T, AdminProviderError>
