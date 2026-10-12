package com.djtech.monai.feature.reports.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias ReportResult<T> = Outcome<T, ReportError>
