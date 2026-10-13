package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import javax.inject.Inject

/** The category the user last gave a [type] transaction with this exact note or merchant, from the cache. */
class FindCategoryForNoteUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    suspend operator fun invoke(text: String, type: TransactionType): String? =
        transactionRepository.findCategoryForNote(text, type)
}
