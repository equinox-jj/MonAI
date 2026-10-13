package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.model.TransactionType

/** The transaction type a phrase suggests, and how sure that guess is. */
data class TypeHint(val type: TransactionType, val confidence: Double)

/** Words that turn a phrase into income (`gajian`, `dapat`) or a transfer (`topup`, `pindah`); expense otherwise. */
object TypeHints {

    private val INCOME = words(
        "gaji", "gajian", "salary", "terima", "nerima", "diterima", "dapat", "dapet", "dpt", "dikasih", "bonus",
        "thr", "refund", "cashback", "pemasukan", "income", "receive", "received",
    )
    private val TRANSFER = words("top ?up", "isi saldo", "pindah", "pindahin", "tarik tunai", "setor", "nabung")

    fun detect(text: String): TypeHint = when {
        TRANSFER.containsMatchIn(text) -> TypeHint(TransactionType.TRANSFER, 0.85)
        INCOME.containsMatchIn(text) -> TypeHint(TransactionType.INCOME, 0.85)
        else -> TypeHint(TransactionType.EXPENSE, 0.9)
    }

    private fun words(vararg patterns: String) = Regex("""(?<!\w)(${patterns.joinToString("|")})(?!\w)""")
}
