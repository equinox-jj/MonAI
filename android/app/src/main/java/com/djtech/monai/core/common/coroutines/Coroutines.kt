package com.djtech.monai.core.common.coroutines

import kotlinx.coroutines.flow.SharingStarted
import javax.inject.Qualifier

enum class MonAIDispatcher { Default, IO }

/** Injects a [kotlinx.coroutines.CoroutineDispatcher] so tests can swap in a test dispatcher. */
@Qualifier
@Retention(AnnotationRetention.RUNTIME)
annotation class Dispatcher(val dispatcher: MonAIDispatcher)

/** Injects the app-wide [kotlinx.coroutines.CoroutineScope] for work that must outlive a screen. */
@Qualifier
@Retention(AnnotationRetention.RUNTIME)
annotation class ApplicationScope

/** For `stateIn` in ViewModels: keeps the upstream alive across configuration changes. */
val WhileUiSubscribed: SharingStarted = SharingStarted.WhileSubscribed(5_000)
