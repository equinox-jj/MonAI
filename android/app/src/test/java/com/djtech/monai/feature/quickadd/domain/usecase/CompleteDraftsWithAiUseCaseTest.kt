package com.djtech.monai.feature.quickadd.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.draftConfidence
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.quickadd.domain.model.DraftEngine
import com.djtech.monai.feature.quickadd.domain.model.QuickAddDrafts
import com.djtech.monai.feature.quickadd.domain.model.QuickAddError
import com.djtech.monai.feature.quickadd.domain.parser.ParseContext
import com.djtech.monai.feature.quickadd.domain.repository.FakeQuickAddRepository
import com.djtech.monai.feature.transactions.domain.usecase.testClock
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class CompleteDraftsWithAiUseCaseTest {

    private val repository = FakeQuickAddRepository()
    private val complete = CompleteDraftsWithAiUseCase(repository, testClock())
    private val context = ParseContext(
        wallets = listOf(wallet("bca", isDefault = true)),
        categories = emptyList(),
        providers = emptyList(),
        today = LocalDate.of(2026, 10, 10),
    )
    private val unsure = draft(
        amount = null,
        categoryId = "other",
        confidence = draftConfidence(amount = 0.0, category = 0.3),
    )

    @Test
    fun `confident local drafts never reach the AI`() = runTest {
        val local = listOf(draft())

        assertEquals(QuickAddDrafts(local, DraftEngine.LOCAL), complete("makan siang 35rb", local, context))
        assertEquals(emptyList<String>(), repository.texts)
    }

    @Test
    fun `unsure drafts are replaced by the AI's, keeping what the phone knew for its gaps`() = runTest {
        repository.result = Outcome.Success(
            listOf(draft(amount = 150_000, walletId = null, note = null, confidence = draftConfidence(wallet = 0.0))),
        )

        val result = complete("bayar arisan 150", listOf(unsure), context)

        assertEquals(DraftEngine.AI, result.engine)
        val drafted = result.drafts.single()
        assertEquals(150_000L, drafted.amount)
        assertEquals("bca", drafted.walletId)
        assertEquals(unsure.confidence.wallet, drafted.confidence.wallet, 0.0)
        assertEquals("Makan siang", drafted.note)
        assertEquals(listOf("bayar arisan 150"), repository.texts)
    }

    @Test
    fun `an AI failure falls back to the local drafts`() = runTest {
        for (error in listOf(QuickAddError.RateLimited, QuickAddError.AiUnavailable, QuickAddError.Network)) {
            repository.result = Outcome.Failure(error)

            assertEquals(QuickAddDrafts(listOf(unsure), DraftEngine.FALLBACK), complete("x", listOf(unsure), context))
        }
    }

    @Test
    fun `a slow AI falls back after three seconds`() = runTest {
        repository.gate = CompletableDeferred()

        assertEquals(DraftEngine.FALLBACK, complete("x", listOf(unsure), context).engine)
        assertEquals(3_000L, testScheduler.currentTime)
    }

    @Test
    fun `an empty AI answer falls back too`() = runTest {
        repository.result = Outcome.Success(emptyList())

        assertEquals(DraftEngine.FALLBACK, complete("x", listOf(unsure), context).engine)
    }
}
