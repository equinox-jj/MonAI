package com.djtech.monai.feature.export.domain.csv

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.export.domain.model.CsvDelimiter

/**
 * Builds the CSV text of an export (RFC 4180): a UTF-8 BOM so Excel reads the file as UTF-8, a
 * header, then one row per transaction, oldest first, each ended by CRLF. Amounts are plain positive
 * rupiah and the type gives the direction, as in the API.
 */
object TransactionCsvWriter {

    private val HEADER = listOf(
        "Date",
        "Type",
        "Amount",
        "Wallet",
        "To wallet",
        "Category",
        "Merchant",
        "Note",
        "Source",
    )

    // A spreadsheet runs a cell starting with one of these as a formula (CSV injection).
    private val FORMULA_STARTS = setOf('=', '+', '-', '@', '\t', '\r')

    private const val BOM = "\uFEFF"
    private const val CRLF = "\r\n"

    /** [walletNames] and [categoryNames] map ids to names; an unknown id leaves its cell blank. */
    fun write(
        transactions: List<Transaction>,
        walletNames: Map<String, String>,
        categoryNames: Map<String, String>,
        delimiter: CsvDelimiter,
    ): String = buildString {
        append(BOM)
        appendRow(HEADER, delimiter.char)
        transactions
            .sortedWith(compareBy<Transaction> { it.date }.thenBy { it.createdAt }.thenBy { it.id })
            .forEach { transaction ->
                appendRow(
                    listOf(
                        transaction.date.toString(),
                        transaction.type.name,
                        transaction.amount.toString(),
                        text(walletNames[transaction.walletId]),
                        text(transaction.toWalletId?.let(walletNames::get)),
                        text(transaction.categoryId?.let(categoryNames::get)),
                        text(transaction.merchant),
                        text(transaction.note),
                        transaction.source.name,
                    ),
                    delimiter.char,
                )
            }
    }

    private fun StringBuilder.appendRow(cells: List<String>, delimiter: Char) {
        cells.joinTo(this, separator = delimiter.toString()) { it.quoted(delimiter) }
        append(CRLF)
    }

    /** User-entered text, with a leading `'` when it would otherwise run as a formula. */
    private fun text(value: String?): String = when {
        value.isNullOrEmpty() -> ""
        value.first() in FORMULA_STARTS -> "'$value"
        else -> value
    }

    private fun String.quoted(delimiter: Char): String =
        if (any { it == delimiter || it == '"' || it == '\n' || it == '\r' }) {
            "\"${replace("\"", "\"\"")}\""
        } else {
            this
        }
}
