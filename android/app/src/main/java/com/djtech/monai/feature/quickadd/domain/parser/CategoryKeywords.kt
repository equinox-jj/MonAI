package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType

/** A category guessed from lowercase text. */
data class CategoryMatch(val categoryId: String, val confidence: Double)

/**
 * Guesses a category from words in a phrase: the user's own category names first, then a keyword
 * map onto the default categories (matched by their English or Indonesian name).
 */
object CategoryKeywords {

    const val NAMED = 0.95
    const val KEYWORD = 0.85

    private class Group(val categoryNames: List<String>, val keywords: List<String>)

    private val GROUPS = listOf(
        Group(
            listOf("food", "makanan", "makan", "food & drink", "makan & minum"),
            listOf(
                "makan", "sarapan", "makan siang", "makan malam", "nasi", "kopi", "ngopi", "bakso", "mie", "mi ayam",
                "sate", "ayam", "jajan", "snack", "cemilan", "minum", "teh", "es teh", "boba", "gofood", "grabfood",
                "shopeefood", "resto", "restoran", "warteg", "warung", "padang", "pizza", "burger", "roti", "kue",
                "martabak", "seblak", "gorengan", "lunch", "dinner", "breakfast", "coffee", "food", "starbucks",
            ),
        ),
        Group(
            listOf("transport", "transportasi"),
            listOf(
                "parkir", "bensin", "bbm", "pertalite", "pertamax", "solar", "ojek", "ojol", "gojek", "goride",
                "gocar", "grab", "grabbike", "grabcar", "taksi", "taxi", "tol", "e-toll", "kereta", "krl", "mrt",
                "lrt", "transjakarta", "busway", "bus", "angkot", "parking", "fuel", "uber",
            ),
        ),
        Group(
            listOf("bills", "tagihan", "bill"),
            listOf(
                "listrik", "pln", "token", "pdam", "pulsa", "kuota", "paket data", "internet", "wifi", "indihome",
                "bpjs", "cicilan", "tagihan", "sewa", "kos", "kost", "kontrakan", "iuran", "electricity", "rent",
                "netflix", "spotify",
            ),
        ),
        Group(
            listOf("shopping", "belanja"),
            listOf(
                "belanja", "baju", "celana", "sepatu", "tas", "shopee", "tokopedia", "tokped", "lazada", "alfamart",
                "indomaret", "supermarket", "groceries", "sabun", "skincare", "shopping",
            ),
        ),
        Group(
            listOf("health", "kesehatan"),
            listOf(
                "obat", "apotek", "apotik", "dokter", "rumah sakit", "klinik", "vitamin", "medicine", "doctor",
                "pharmacy",
            ),
        ),
        Group(
            listOf("entertainment", "hiburan"),
            listOf("nonton", "bioskop", "film", "game", "karaoke", "konser", "liburan", "movie", "cinema", "concert"),
        ),
        Group(listOf("salary", "gaji"), listOf("gaji", "gajian", "salary", "payroll")),
        Group(listOf("bonus"), listOf("bonus", "thr", "insentif", "komisi")),
    )

    /**
     * The category [text] points to among [categories] of [type], or null when nothing matches.
     * Several hits pick the earliest in the text.
     */
    fun find(text: String, categories: List<Category>, type: CategoryType): CategoryMatch? {
        val candidates = categories.filter { it.type == type }
        val byName = candidates.associateBy { it.name.lowercase().trim() }

        byName.entries
            .mapNotNull { (name, category) -> firstIndexOf(name, text)?.let { it to category } }
            .minByOrNull { it.first }
            ?.let { return CategoryMatch(it.second.id, NAMED) }

        return GROUPS
            .mapNotNull { group ->
                val category = group.categoryNames.firstNotNullOfOrNull(byName::get) ?: return@mapNotNull null
                group.keywords.mapNotNull { firstIndexOf(it, text) }.minOrNull()?.let { it to category }
            }
            .minByOrNull { it.first }
            ?.let { CategoryMatch(it.second.id, KEYWORD) }
    }

    private fun firstIndexOf(word: String, text: String): Int? =
        Regex("""(?<![\w-])${Regex.escape(word)}(?![\w-])""").find(text)?.range?.first
}
