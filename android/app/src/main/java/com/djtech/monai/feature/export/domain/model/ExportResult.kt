package com.djtech.monai.feature.export.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias ExportResult<T> = Outcome<T, ExportError>
