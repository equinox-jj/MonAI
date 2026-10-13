package com.djtech.monai.feature.quickadd.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias QuickAddResult<T> = Outcome<T, QuickAddError>
