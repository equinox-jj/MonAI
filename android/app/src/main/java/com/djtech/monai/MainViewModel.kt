package com.djtech.monai

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.flow.WhileUiSubscribed
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.datastore.SessionStore
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import javax.inject.Inject

/** Drives the app root: the splash stays up while Loading, then auth or main is shown. */
@HiltViewModel
class MainViewModel @Inject constructor(sessionStore: SessionStore) : ViewModel() {
    val sessionState: StateFlow<SessionState> = sessionStore.sessionState
        .stateIn(viewModelScope, WhileUiSubscribed, SessionState.Loading)
}
