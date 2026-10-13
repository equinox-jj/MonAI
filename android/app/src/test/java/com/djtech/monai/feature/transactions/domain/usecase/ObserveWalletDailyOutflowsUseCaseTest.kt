package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class ObserveWalletDailyOutflowsUseCaseTest {

    @Test
    fun `emits each day's money out of the wallet in the month`() = runTest {
        val repository = FakeTransactionRepository(
            listOf(
                transaction("lunch", walletId = "bca", amount = 35_000),
                transaction(
                    "top-up",
                    walletId = "bca",
                    type = TransactionType.TRANSFER,
                    toWalletId = "gopay",
                    categoryId = null,
                    amount = 500_000,
                ),
                transaction("gopay-lunch", walletId = "gopay"),
                transaction("september", walletId = "bca", date = LocalDate.of(2026, 9, 30)),
            ),
        )

        val outflows = ObserveWalletDailyOutflowsUseCase(repository)(OCTOBER, walletId = "bca").first()

        assertEquals(mapOf(LocalDate.of(2026, 10, 10) to 535_000L), outflows)
    }
}
