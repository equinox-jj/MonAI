package com.djtech.monai.feature.categories.presentation.categoryform

import androidx.annotation.StringRes
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryNameIssue
import com.djtech.monai.feature.categories.domain.usecase.CreateCategoryUseCase
import com.djtech.monai.feature.categories.domain.validation.MAX_CATEGORY_NAME_LENGTH
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

/** Creates a custom category of [type]: a name, an icon and a color. */
@HiltViewModel(assistedFactory = CategoryFormViewModel.Factory::class)
class CategoryFormViewModel @AssistedInject constructor(
    @Assisted type: CategoryType,
    private val createCategory: CreateCategoryUseCase,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(type: CategoryType): CategoryFormViewModel
    }

    private val mutableState = MutableStateFlow(CategoryFormState(type = type))
    val state: StateFlow<CategoryFormState> = mutableState.asStateFlow()

    private val effectChannel = Channel<CategoryFormEffect>(Channel.BUFFERED)
    val effects: Flow<CategoryFormEffect> = effectChannel.receiveAsFlow()

    fun onIntent(intent: CategoryFormIntent) {
        when (intent) {
            is CategoryFormIntent.NameChanged -> mutableState.update {
                it.copy(name = intent.name.take(MAX_CATEGORY_NAME_LENGTH), nameError = null)
            }

            is CategoryFormIntent.PickIcon -> mutableState.update { it.copy(icon = intent.icon) }
            is CategoryFormIntent.PickColor -> mutableState.update { it.copy(color = intent.color) }
            CategoryFormIntent.Save -> save()
            CategoryFormIntent.Close -> send(CategoryFormEffect.Close)
        }
    }

    private fun save() {
        val form = mutableState.value
        if (!form.canSave) return
        mutableState.update { it.copy(isSaving = true, nameError = null) }
        viewModelScope.launch {
            val input = CategoryInput(
                name = form.name,
                type = form.type,
                icon = form.icon.symbol,
                color = form.color.hex,
            )
            val result = createCategory(input)
            mutableState.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> send(CategoryFormEffect.Close)
                is Outcome.Failure -> when (val error = result.error) {
                    is CategoryError.InvalidName -> mutableState.update { it.copy(nameError = error.issue.message()) }
                    CategoryError.Network -> showMessage(R.string.category_form_error_network)
                    CategoryError.Unexpected -> showMessage(R.string.category_form_error_unexpected)
                }
            }
        }
    }

    private fun showMessage(@StringRes message: Int) = send(CategoryFormEffect.ShowMessage(UiText.Resource(message)))

    private fun send(effect: CategoryFormEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

private fun CategoryNameIssue.message(): UiText = when (this) {
    CategoryNameIssue.REQUIRED -> UiText.Resource(R.string.category_form_name_required)
    CategoryNameIssue.TOO_LONG -> UiText.Resource(R.string.category_form_name_too_long, MAX_CATEGORY_NAME_LENGTH)
    CategoryNameIssue.ALREADY_EXISTS -> UiText.Resource(R.string.category_form_name_taken)
    CategoryNameIssue.INVALID -> UiText.Resource(R.string.category_form_name_invalid)
}
