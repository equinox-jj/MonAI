package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.category
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class CategoryKeywordsTest {

    private val categories = listOf(
        category("food", name = "Food"),
        category("transport", name = "Transport"),
        category("pets", name = "Kucing", isDefault = false),
        category("salary", name = "Salary", type = CategoryType.INCOME),
    )

    private fun find(text: String, type: CategoryType = CategoryType.EXPENSE) =
        CategoryKeywords.find(text, categories, type)

    @Test
    fun `the user's own category name beats keywords`() {
        assertEquals(CategoryMatch("pets", CategoryKeywords.NAMED), find("makanan kucing 50rb"))
    }

    @Test
    fun `keywords map onto default categories`() {
        assertEquals(CategoryMatch("food", CategoryKeywords.KEYWORD), find("ngopi 25rb"))
        assertEquals(CategoryMatch("transport", CategoryKeywords.KEYWORD), find("isi bensin"))
        assertEquals(CategoryMatch("salary", CategoryKeywords.KEYWORD), find("gajian", CategoryType.INCOME))
    }

    @Test
    fun `the earliest keyword wins`() {
        assertEquals("transport", find("parkir di resto")?.categoryId)
    }

    @Test
    fun `keywords for the other type or a missing category match nothing`() {
        assertNull(find("gajian"))
        assertNull(find("obat"))
    }
}
