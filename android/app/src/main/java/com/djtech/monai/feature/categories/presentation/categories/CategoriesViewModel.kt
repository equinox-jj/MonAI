package com.djtech.monai.feature.categories.presentation.categories

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.common.ui.RefreshStatus
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.usecase.DeleteCategoryUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.RefreshCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.SetCategoryHiddenUseCase
import com.djtech.monai.feature.categories.presentation.categories.mapper.message
import com.djtech.monai.feature.categories.presentation.categories.mapper.sortedForList
import com.djtech.monai.feature.categories.presentation.categories.mapper.toRow
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryDeletion
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryKind
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Every category by type: hide or show defaults, delete custom ones (moving their transactions
 * when they have any), and open the form to add or edit.
 */
@HiltViewModel
class CategoriesViewModel @Inject constructor(
    private val refreshCategories: RefreshCategoriesUseCase,
    private val setCategoryHidden: SetCategoryHiddenUseCase,
    private val deleteCategory: DeleteCategoryUseCase,
    observeCategories: ObserveCategoriesUseCase,
) : ViewModel() {

    private val ui = MutableStateFlow(Ui())

    // Eager, so intents can look a category up even before the screen subscribes.
    private val categories: StateFlow<List<Category>> = observeCategories().stateIn(
        viewModelScope,
        SharingStarted.Eagerly,
        emptyList(),
    )

    val state: StateFlow<CategoriesState> = combine(categories, ui) { all, ui ->
        val rows = all
            .filter { it.type == ui.type }
            .sortedForList()
            .map { it.toRow(isBusy = it.id in ui.busyIds) }

        CategoriesState(
            type = ui.type,
            isLoading = ui.load.isLoading(hasCache = all.isNotEmpty()),
            loadError = ui.load.loadFailure(hasCache = all.isNotEmpty())?.message(),
            rows = rows,
            deletion = ui.deletion,
        )
    }.stateIn(
        viewModelScope,
        WhileUiSubscribed,
        CategoriesState(),
    )

    private val effectQueue = EffectQueue<CategoriesEffect>()
    val effects: Flow<CategoriesEffect> = effectQueue.flow

    init {
        refresh()
    }

    fun onIntent(intent: CategoriesIntent) {
        when (intent) {
            is CategoriesIntent.SelectType -> ui.update { it.copy(type = intent.type) }
            CategoriesIntent.Retry -> refresh()
            CategoriesIntent.Back -> effectQueue.send(CategoriesEffect.Close)
            CategoriesIntent.Add ->
                effectQueue.send(CategoriesEffect.Navigate(CategoriesDestination.New(ui.value.type)))

            is CategoriesIntent.Edit -> find(intent.id)?.takeIf { !it.isSystem }?.let {
                effectQueue.send(CategoriesEffect.Navigate(CategoriesDestination.Edit(it.type, it.id)))
            }

            is CategoriesIntent.SetHidden -> setHidden(intent.id, intent.hidden)
            is CategoriesIntent.Delete -> find(intent.id)?.toRow()?.takeIf { it.canDelete }?.let { row ->
                ui.update { it.copy(deletion = CategoryDeletion(row)) }
            }

            CategoriesIntent.ConfirmDelete -> delete()
            is CategoriesIntent.PickTarget -> ui.update {
                it.copy(deletion = it.deletion?.copy(targetId = intent.id))
            }

            CategoriesIntent.DismissDelete -> if (ui.value.deletion?.isDeleting != true) {
                ui.update { it.copy(deletion = null) }
            }
        }
    }

    private fun find(id: String): Category? = categories.value.firstOrNull { it.id == id }

    private fun refresh() {
        ui.update { it.copy(load = it.load.started()) }
        viewModelScope.launch {
            val error = (refreshCategories() as? Outcome.Failure)?.error
            ui.update { it.copy(load = it.load.finished(error)) }
        }
    }

    private fun setHidden(id: String, hidden: Boolean) {
        if (id in ui.value.busyIds) return
        ui.update { it.copy(busyIds = it.busyIds + id) }
        viewModelScope.launch {
            val result = setCategoryHidden(id, hidden)
            ui.update { it.copy(busyIds = it.busyIds - id) }
            if (result is Outcome.Failure) effectQueue.send(CategoriesEffect.ShowMessage(result.error.message()))
        }
    }

    private fun delete() {
        val deletion = ui.value.deletion ?: return
        if (deletion.isDeleting || (deletion.needsTarget && deletion.targetId == null)) return
        ui.update { it.copy(deletion = deletion.copy(isDeleting = true)) }
        viewModelScope.launch {
            when (val result = deleteCategory(deletion.category.id, deletion.targetId)) {
                is Outcome.Success -> {
                    ui.update { it.copy(deletion = null) }
                    effectQueue.send(
                        CategoriesEffect.ShowMessage(
                            UiText.Resource(R.string.categories_deleted, deletion.category.name),
                        ),
                    )
                }

                is Outcome.Failure if result.error == CategoryError.HasTransactions ->
                    ui.update { it.copy(deletion = deletion.withTargets()) }

                is Outcome.Failure -> {
                    ui.update { it.copy(deletion = null) }
                    effectQueue.send(CategoriesEffect.ShowMessage(result.error.message()))
                }
            }
        }
    }

    /** The move sheet: every other category of the same type, "Other" picked first. */
    private fun CategoryDeletion.withTargets(): CategoryDeletion {
        val type = find(category.id)?.type ?: ui.value.type
        val targets = categories.value
            .filter { it.type == type && it.id != category.id }
            .sortedForList()
            .map { it.toRow() }
        return copy(
            needsTarget = true,
            targets = targets,
            targetId = targets.firstOrNull { it.kind == CategoryKind.SYSTEM }?.id ?: targets.firstOrNull()?.id,
            isDeleting = false,
        )
    }
}

/** Screen-local state; the categories come from the cache. */
private data class Ui(
    val type: CategoryType = CategoryType.EXPENSE,
    val load: RefreshStatus<CategoryError> = RefreshStatus(),
    val busyIds: Set<String> = emptySet(),
    val deletion: CategoryDeletion? = null,
)
