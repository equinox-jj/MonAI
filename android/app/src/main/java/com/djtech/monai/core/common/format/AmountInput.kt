package com.djtech.monai.core.common.format

/** The largest amount the API accepts, in rupiah. */
const val MAX_AMOUNT = 999_999_999_999L

private val MAX_DIGITS = MAX_AMOUNT.toString().length

/**
 * Reads an amount from raw or formatted text (`35000`, `Rp 35.000`), ignoring
 * everything but digits. Null when there are no digits or the value passes [MAX_AMOUNT].
 */
fun parseAmount(input: String): Long? {
    val digits = input.filter { it in '0'..'9' }
    if (digits.isEmpty()) return null
    val significant = digits.trimStart('0').ifEmpty { "0" }
    if (significant.length > MAX_DIGITS) return null
    return significant.toLong().takeIf { it <= MAX_AMOUNT }
}

/** Keypad entry: `35` + `0` = `350`. A digit that would pass [MAX_AMOUNT] is ignored. */
fun appendDigit(current: Long, digit: Int): Long {
    require(digit in 0..9) { "Not a digit: $digit" }
    if (current > (MAX_AMOUNT - digit) / 10) return current
    return current * 10 + digit
}

/** Keypad backspace: `350` becomes `35`. */
fun deleteDigit(current: Long): Long = current / 10
