package com.djtech.monai.feature.quickadd.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.isLowConfidence
import com.djtech.monai.feature.quickadd.domain.parser.CategoryKeywords
import com.djtech.monai.feature.quickadd.domain.repository.QuickAddRepository
import com.djtech.monai.feature.transactions.domain.usecase.FindCategoryForNoteUseCase
import kotlinx.coroutines.withTimeoutOrNull
import javax.inject.Inject
import kotlin.time.Duration.Companion.seconds

/**
 * Auto-categorization for a typed note or merchant: the category the user gave the same text
 * before, then the keyword map, then the AI. Only [categories] (the visible ones of the
 * transaction's type) can be suggested; null when nothing fits.
 */
class SuggestCategoryUseCase @Inject constructor(
    private val findCategoryForNote: FindCategoryForNoteUseCase,
    private val quickAddRepository: QuickAddRepository,
    private val clock: AppClock,
) {
    suspend operator fun invoke(text: String, type: TransactionType, categories: List<Category>): String? {
        val note = text.trim()
        if (note.isEmpty() || type == TransactionType.TRANSFER) return null
        val allowed = categories.map { it.id }.toSet()
        findCategoryForNote(note, type)?.takeIf { it in allowed }?.let { return it }

        val categoryType = if (type == TransactionType.INCOME) CategoryType.INCOME else CategoryType.EXPENSE
        CategoryKeywords.find(note.lowercase(), categories, categoryType)?.let { return it.categoryId }

        if (note.length < MIN_AI_TEXT) return null
        val result = withTimeoutOrNull(AI_TIMEOUT) {
            quickAddRepository.parse(note.take(MAX_TEXT), clock.today(), clock.zone())
        }
        return (result as? Outcome.Success)?.data
            ?.firstOrNull { it.type == null || it.type == type }
            ?.takeIf { !it.confidence.category.isLowConfidence() }
            ?.categoryId
            ?.takeIf { it in allowed }
    }

    private companion object {
        val AI_TIMEOUT = 3.seconds
        const val MIN_AI_TEXT = 3
        const val MAX_TEXT = 300
    }
}
