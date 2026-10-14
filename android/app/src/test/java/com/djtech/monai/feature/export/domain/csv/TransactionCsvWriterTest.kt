package com.djtech.monai.feature.export.domain.csv

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.export.domain.model.CsvDelimiter
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.Instant
import java.time.LocalDate

class TransactionCsvWriterTest {

    private val wallets = mapOf("bca" to "BCA", "gopay" to "GoPay")
    private val categories = mapOf("food" to "Makanan")

    private fun write(vararg transactions: Transaction, delimiter: CsvDelimiter = CsvDelimiter.COMMA) =
        TransactionCsvWriter.write(
            transactions.toList(),
            wallets,
            categories,
            delimiter,
        )

    private fun rows(csv: String) = csv.removePrefix(BOM).removeSuffix(CRLF).split(CRLF)

    @Test
    fun `starts with a BOM and a header, and ends every row with CRLF`() {
        val csv = write(transaction("a"))

        assertTrue(csv.startsWith(BOM))
        assertTrue(csv.endsWith(CRLF))
        assertEquals(HEADER, rows(csv).first())
        assertEquals(2, rows(csv).size)
    }

    @Test
    fun `writes each field, with names for the wallet and category`() {
        val csv = write(
            transaction(
                "a",
                date = LocalDate.of(2026, 10, 5),
                amount = 35_000,
                note = "Makan siang",
                merchant = "Warteg Bahari",
                source = TransactionSource.QUICK_ADD,
            ),
            transaction(
                "b",
                date = LocalDate.of(2026, 10, 6),
                type = TransactionType.TRANSFER,
                amount = 500_000,
                toWalletId = "gopay",
                categoryId = null,
            ),
        )

        assertEquals(
            listOf(
                HEADER,
                "2026-10-05,EXPENSE,35000,BCA,,Makanan,Warteg Bahari,Makan siang,QUICK_ADD",
                "2026-10-06,TRANSFER,500000,BCA,GoPay,,,,MANUAL",
            ),
            rows(csv),
        )
    }

    @Test
    fun `leaves names it does not know blank`() {
        val csv = write(transaction("a", walletId = "gone", categoryId = "gone"))

        assertEquals("2026-10-10,EXPENSE,35000,,,,,,MANUAL", rows(csv)[1])
    }

    @Test
    fun `lists oldest first, then by creation time`() {
        val csv = write(
            transaction("late", date = LocalDate.of(2026, 10, 9), note = "late"),
            transaction("early", date = LocalDate.of(2026, 10, 1), note = "early"),
            transaction(
                "second",
                date = LocalDate.of(2026, 10, 9),
                note = "second",
                createdAt = Instant.parse("2026-10-09T01:00:00Z"),
            ),
        )

        assertEquals(listOf("early", "second", "late"), rows(csv).drop(1).map { it.split(",")[7] })
    }

    @Test
    fun `semicolon separates the cells and leaves commas unquoted`() {
        val csv = write(transaction("a", note = "Nasi, teh"), delimiter = CsvDelimiter.SEMICOLON)

        assertEquals(HEADER.replace(',', ';'), rows(csv).first())
        assertEquals("2026-10-10;EXPENSE;35000;BCA;;Makanan;;Nasi, teh;MANUAL", rows(csv)[1])
    }

    @Test
    fun `quotes cells with the delimiter, quotes or line breaks, doubling the quotes`() {
        val csv = write(transaction("a", note = "Kopi \"susu\", 2x\nlagi", merchant = "Toko; Jaya"))

        // The note keeps its line break inside the quotes; only CRLF ends a row.
        assertEquals(
            "2026-10-10,EXPENSE,35000,BCA,,Makanan,Toko; Jaya,\"Kopi \"\"susu\"\", 2x\nlagi\",MANUAL",
            rows(csv)[1],
        )
    }

    @Test
    fun `prefixes text that a spreadsheet would run as a formula`() {
        val csv = write(
            transaction("a", note = "=HYPERLINK(\"x\")", merchant = "+62 shop"),
            transaction("b", note = "-50 refund", merchant = "@home"),
        )

        assertEquals(
            listOf(
                "2026-10-10,EXPENSE,35000,BCA,,Makanan,'+62 shop,\"'=HYPERLINK(\"\"x\"\")\",MANUAL",
                "2026-10-10,EXPENSE,35000,BCA,,Makanan,'@home,'-50 refund,MANUAL",
            ),
            rows(csv).drop(1),
        )
    }

    @Test
    fun `an empty list is only the header`() {
        assertEquals(listOf(HEADER), rows(write()))
    }

    private companion object {
        const val BOM = "\uFEFF"
        const val CRLF = "\r\n"
        const val HEADER = "Date,Type,Amount,Wallet,To wallet,Category,Merchant,Note,Source"
    }
}
