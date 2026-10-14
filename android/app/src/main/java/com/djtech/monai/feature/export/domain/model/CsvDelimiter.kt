package com.djtech.monai.feature.export.domain.model

/** What separates the cells of a row. Spreadsheets set to Indonesian expect a semicolon. */
enum class CsvDelimiter(val char: Char) {
    COMMA(','),
    SEMICOLON(';'),
}
