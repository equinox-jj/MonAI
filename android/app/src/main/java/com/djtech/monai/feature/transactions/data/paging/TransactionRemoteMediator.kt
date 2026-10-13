package com.djtech.monai.feature.transactions.data.paging

import androidx.paging.ExperimentalPagingApi
import androidx.paging.LoadType
import androidx.paging.PagingState
import androidx.paging.RemoteMediator
import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.catching
import com.djtech.monai.core.common.result.getOrElse
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.database.dao.TransactionDao
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.TransactionRemoteKeyEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.feature.transactions.data.mapper.asModel
import com.djtech.monai.feature.transactions.data.mapper.toTransactionError
import com.djtech.monai.feature.transactions.data.remote.TransactionApiService
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.model.TransactionLoadException
import java.time.YearMonth

/**
 * Fills the cache for one month's list, page by page, following the API's cursor. The list itself
 * is read from Room, so it works offline and updates when a write lands in the cache.
 */
@OptIn(ExperimentalPagingApi::class)
class TransactionRemoteMediator(
    private val month: YearMonth,
    private val filter: TransactionFilter,
    private val transactionApiService: TransactionApiService,
    private val apiCaller: ApiCaller,
    private val transactionDao: TransactionDao,
    private val clock: AppClock,
    private val errorLogger: ErrorLogger,
) : RemoteMediator<Int, TransactionEntity>() {

    private val queryKey = queryKeyOf(month, filter)

    override suspend fun load(loadType: LoadType, state: PagingState<Int, TransactionEntity>): MediatorResult {
        val cursor = when (loadType) {
            LoadType.REFRESH -> null
            // The list is newest first and the API only pages forward.
            LoadType.PREPEND -> return MediatorResult.Success(endOfPaginationReached = true)
            LoadType.APPEND -> transactionDao.remoteKey(queryKey)?.nextCursor
                ?: return MediatorResult.Success(endOfPaginationReached = true)
        }
        // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
        val result = apiCaller.callRaw {
            val page = transactionApiService.getTransactions(
                month = month.toApiString(),
                limit = state.config.pageSize,
                walletId = filter.walletId,
                categoryId = filter.categoryId,
                type = filter.type,
                cursor = cursor,
            )
            Page(
                transactions = page.data.map { it.asModel().asEntity() },
                nextCursor = page.meta.nextCursor.takeIf { page.meta.hasMore },
            )
        }
        return when (result) {
            is Outcome.Success -> cache(loadType, result.data)
            is Outcome.Failure -> MediatorResult.Error(TransactionLoadException(result.error.toTransactionError()))
        }
    }

    private suspend fun cache(loadType: LoadType, page: Page): MediatorResult = catching<MediatorResult> {
        val key = TransactionRemoteKeyEntity(queryKey, page.nextCursor, clock.now())
        if (loadType == LoadType.REFRESH) {
            transactionDao.replaceQueryPage(
                from = month.atDay(1),
                to = month.atEndOfMonth(),
                walletId = filter.walletId,
                categoryId = filter.categoryId,
                type = filter.type,
                transactions = page.transactions,
                key = key,
            )
        } else {
            transactionDao.appendQueryPage(page.transactions, key)
        }
        MediatorResult.Success(endOfPaginationReached = page.nextCursor == null)
    }.getOrElse { e ->
        errorLogger.log("Caching a transactions page failed", e)
        MediatorResult.Error(TransactionLoadException(TransactionError.Unexpected))
    }

    private class Page(val transactions: List<TransactionEntity>, val nextCursor: String?)

    companion object {
        /** One remote key per month and filter combination, e.g. `2026-10|bca||EXPENSE`. */
        fun queryKeyOf(month: YearMonth, filter: TransactionFilter): String = listOf(
            month.toApiString(),
            filter.walletId.orEmpty(),
            filter.categoryId.orEmpty(),
            filter.type?.name.orEmpty(),
        ).joinToString("|")
    }
}
