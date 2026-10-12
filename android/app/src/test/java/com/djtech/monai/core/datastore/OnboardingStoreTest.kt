package com.djtech.monai.core.datastore

import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class OnboardingStoreTest {

    private val dataStore = InMemoryPreferencesDataStore()

    @Test
    fun `is not completed on a fresh install`() = runTest {
        assertFalse(OnboardingStore(dataStore).isCompleted.first())
    }

    @Test
    fun `stays completed once marked`() = runTest {
        OnboardingStore(dataStore).markCompleted()

        // A new instance reads it back, as the next app launch would.
        assertTrue(OnboardingStore(dataStore).isCompleted.first())
    }
}
