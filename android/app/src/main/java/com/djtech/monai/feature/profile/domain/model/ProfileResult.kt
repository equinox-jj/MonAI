package com.djtech.monai.feature.profile.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias ProfileResult<T> = Outcome<T, ProfileError>
