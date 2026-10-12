package com.djtech.monai.feature.categories.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias CategoryResult<T> = Outcome<T, CategoryError>
