package com.djtech.monai.core.common.format

private val WHITESPACE = Regex("\\s+")

/** `JP` for "Joshua Putra Jeremia": the first letters of the first two words. */
fun initialsOf(name: String): String =
    name.trim().split(WHITESPACE).filter(String::isNotEmpty).take(2)
        .joinToString("") { it.first().uppercase() }

/**
 * A wallet's logo stand-in: `BCA` for "BCA Tabungan", `GP` for "GoPay", `BJ` for "Bank Jago".
 * Provider logos replace it once images load.
 */
fun walletMonogram(name: String): String {
    val words = name.trim().split(WHITESPACE).filter(String::isNotEmpty)
    val first = words.firstOrNull() ?: return ""
    if (first.length <= 3) return first.uppercase()
    if (words.size > 1) return initialsOf(name)
    val capitals = first.filter(Char::isUpperCase)
    return if (capitals.length >= 2) capitals.take(2) else first.take(2).uppercase()
}
