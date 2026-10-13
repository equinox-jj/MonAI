package com.djtech.monai.navigation

import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.draftConfidence
import com.djtech.monai.core.model.receiptDraft
import kotlinx.serialization.json.Json
import org.junit.Assert.assertEquals
import org.junit.Test

class DraftKeysTest {

    @Test
    fun `a draft survives the trip through a serialized route`() {
        val original = draft(amount = null, date = null, confidence = draftConfidence(amount = 0.0))
        val route = QuickAddReviewRoute("kopi", listOf(original.toKey()))

        val json = Json.encodeToString(QuickAddReviewRoute.serializer(), route)
        val restored = Json.decodeFromString(QuickAddReviewRoute.serializer(), json)

        assertEquals(listOf(original), restored.drafts.map { it.toModel() })
    }

    @Test
    fun `a receipt draft keeps its items`() {
        val original = receiptDraft()

        assertEquals(original, original.toKey().toModel())
    }
}
