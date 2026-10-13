package com.djtech.monai.feature.categories.presentation.categoryform

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.assertIsSelected
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollTo
import androidx.compose.ui.test.performTextReplacement
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryColorChoice
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryIconChoice
import com.djtech.monai.feature.categories.presentation.categoryform.preview.CategoryFormPreviewData
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class CategoryFormScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val intents = mutableListOf<CategoryFormIntent>()

    private fun setContent(state: CategoryFormState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { CategoryFormScreen(state, onIntent = { intents += it }) }
        }
    }

    @Test
    fun showsTheNameTypeAndCount() {
        setContent(CategoryFormPreviewData.state)

        compose.onNodeWithText("New category").assertIsDisplayed()
        compose.onNodeWithText("Expense category · 4/30").assertIsDisplayed()
        compose.onNodeWithContentDescription("Coffee").assertIsSelected()
    }

    @Test
    fun anEmptyNameCantBeSaved() {
        setContent(CategoryFormState(type = CategoryType.INCOME))

        compose.onNodeWithText("Save").assertIsNotEnabled()
        compose.onNodeWithText("Income category · 0/30").assertIsDisplayed()
    }

    @Test
    fun editsSendTheirIntents() {
        setContent(CategoryFormPreviewData.state)

        compose.onNodeWithText("Kopi").performTextReplacement("Kopi susu")
        compose.onNodeWithContentDescription("Pets").performScrollTo().performClick()
        compose.onNodeWithContentDescription("Teal").performScrollTo().performClick()
        compose.onNodeWithText("Save").performClick()

        assertEquals(
            listOf(
                CategoryFormIntent.NameChanged("Kopi susu"),
                CategoryFormIntent.PickIcon(CategoryIconChoice.Pets),
                CategoryFormIntent.PickColor(CategoryColorChoice.Teal),
                CategoryFormIntent.Save,
            ),
            intents,
        )
    }

    @Test
    fun aTakenNameIsShownUnderTheField() {
        setContent(CategoryFormPreviewData.state.copy(nameError = UiText.Resource(R.string.category_form_name_taken)))

        compose.onNodeWithText("You already have a category with this name.").assertIsDisplayed()
    }
}
