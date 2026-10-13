package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** The id of each provider as it changes, so the admin list can reload. */
class ObserveProviderChangesUseCase @Inject constructor(private val changeEvents: ProviderChangeEvents) {
    operator fun invoke(): Flow<String> = changeEvents.changed
}
