package com.djtech.monai.feature.wallets.domain.repository

import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import kotlinx.coroutines.flow.Flow

/** The payment provider catalog, used as templates when adding a wallet. */
interface PaymentProviderRepository {

    /**
     * Cached providers by sort order. Before the first refresh, the bundled seed catalog, whose
     * entries have an empty id and are matched by slug.
     */
    fun observeProviders(): Flow<List<PaymentProvider>>

    /** Fetches the catalog when its version changed (ETag) and replaces the cache. */
    suspend fun refresh(): WalletResult<Unit>
}
