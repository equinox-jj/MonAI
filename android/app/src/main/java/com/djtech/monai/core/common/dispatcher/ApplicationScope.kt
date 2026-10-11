package com.djtech.monai.core.common.dispatcher

import javax.inject.Qualifier

/** Injects the app-wide [kotlinx.coroutines.CoroutineScope] for work that must outlive a screen. */
@Qualifier
@Retention(AnnotationRetention.RUNTIME)
annotation class ApplicationScope
