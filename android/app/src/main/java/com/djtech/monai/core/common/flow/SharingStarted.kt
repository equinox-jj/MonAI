package com.djtech.monai.core.common.flow

import kotlinx.coroutines.flow.SharingStarted

/** For `stateIn` in ViewModels: keeps the upstream alive across configuration changes. */
val WhileUiSubscribed: SharingStarted = SharingStarted.WhileSubscribed(5_000)
