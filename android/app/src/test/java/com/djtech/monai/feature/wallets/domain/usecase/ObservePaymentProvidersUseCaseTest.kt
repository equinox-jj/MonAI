package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.paymentProvider
import com.djtech.monai.feature.wallets.domain.repository.FakePaymentProviderRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ObservePaymentProvidersUseCaseTest {

    @Test
    fun `emits the catalog from the repository`() = runTest {
        val catalog = listOf(paymentProvider("cash"), paymentProvider("bca"))

        assertEquals(catalog, ObservePaymentProvidersUseCase(FakePaymentProviderRepository(catalog))().first())
    }
}
