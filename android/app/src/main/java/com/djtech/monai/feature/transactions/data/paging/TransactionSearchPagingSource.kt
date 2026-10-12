package com.djtech.monai.feature.transactions.data.paging

import androidx.paging.PagingSource
import androidx.paging.PagingState
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionLoadException
import com.djtech.monai.feature.transactions.domain.model.TransactionResult

/** One page of a network list and the cursor of the next, null on the last page. */
class TransactionPage(val transactions: List<Transaction>, val nextCursor: String?)

/**
 * Pages a search straight from the API. Server search matches anywhere in the text, which the
 * cache's word-prefix FTS can't reproduce, so these results aren't read back from Room.
 */
class TransactionSearchPagingSource(
    private val fetch: suspend (cursor: String?, limit: Int) -> TransactionResult<TransactionPage>,
) : PagingSource<String, Transaction>() {

    override suspend fun load(params: LoadParams<String>): LoadResult<String, Transaction> =
        when (val result = fetch(params.key, params.loadSize)) {
            is Outcome.Success -> LoadResult.Page(
                data = result.data.transactions,
                prevKey = null,
                nextKey = result.data.nextCursor,
            )

            is Outcome.Failure -> LoadResult.Error(TransactionLoadException(result.error))
        }

    // Cursors only lead forward, so a refresh starts over from the first page.
    override fun getRefreshKey(state: PagingState<String, Transaction>): String? = null
}
