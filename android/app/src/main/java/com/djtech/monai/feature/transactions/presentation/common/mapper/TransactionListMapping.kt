package com.djtech.monai.feature.transactions.presentation.common.mapper

import androidx.paging.PagingData
import androidx.paging.insertSeparators
import androidx.paging.map
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionListItem

/** Puts a day header above the first transaction of each date. Lists are newest first. */
fun PagingData<Transaction>.withDayHeaders(): PagingData<TransactionListItem> =
    map<Transaction, TransactionListItem> { TransactionListItem.Entry(it) }
        .insertSeparators { before, after ->
            val next = (after as? TransactionListItem.Entry)?.transaction ?: return@insertSeparators null
            val previous = (before as? TransactionListItem.Entry)?.transaction
            if (previous?.date == next.date) null else TransactionListItem.Day(next.date)
        }
