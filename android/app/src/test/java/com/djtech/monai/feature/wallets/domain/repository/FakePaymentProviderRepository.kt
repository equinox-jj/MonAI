package com.djtech.monai.feature.wallets.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow

/** Serves [providers]; a successful refresh swaps in [catalogAfterRefresh] when it is set. */
class FakePaymentProviderRepository(providers: List<PaymentProvider> = emptyList()) : PaymentProviderRepository {
    val providers = MutableStateFlow(providers)
    var refreshResult: WalletResult<Unit> = Outcome.Success(Unit)
    var catalogAfterRefresh: List<PaymentProvider>? = null
    var refreshCount = 0

    override fun observeProviders(): Flow<List<PaymentProvider>> = providers

    override suspend fun refresh(): WalletResult<Unit> {
        refreshCount++
        val result = refreshResult
        if (result is Outcome.Success) catalogAfterRefresh?.let { providers.value = it }
        return result
    }
}
