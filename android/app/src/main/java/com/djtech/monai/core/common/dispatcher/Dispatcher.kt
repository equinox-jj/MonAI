package com.djtech.monai.core.common.dispatcher

import javax.inject.Qualifier

enum class MonAIDispatcher { Default, IO }

/** Injects a [kotlinx.coroutines.CoroutineDispatcher] so tests can swap in a test dispatcher. */
@Qualifier
@Retention(AnnotationRetention.RUNTIME)
annotation class Dispatcher(val dispatcher: MonAIDispatcher)
