package com.djtech.monai.core.common.ui

import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.receiveAsFlow

/**
 * A ViewModel's one-off effects (navigation, snackbars). Buffered, so effects sent while the screen
 * is stopped wait for [CollectEffects]; each one is handled once.
 */
class EffectQueue<E> {
    private val channel = Channel<E>(Channel.BUFFERED)

    val flow: Flow<E> = channel.receiveAsFlow()

    /** Never suspends: the buffer only fills if the screen stops collecting for good. */
    fun send(effect: E) {
        channel.trySend(effect)
    }
}
