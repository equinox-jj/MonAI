package com.djtech.monai.feature.settings.domain.event

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import javax.inject.Inject
import javax.inject.Singleton

/**
 * The id of each provider created, edited, (de)activated or deleted, so the admin list reloads
 * after the form closes. A singleton because the form and the list don't share a scope. Nothing
 * is replayed.
 */
@Singleton
class ProviderChangeEvents @Inject constructor() {
    private val changedProviders = MutableSharedFlow<String>(extraBufferCapacity = 8)
    val changed: Flow<String> = changedProviders.asSharedFlow()

    suspend fun emit(providerId: String) = changedProviders.emit(providerId)
}
