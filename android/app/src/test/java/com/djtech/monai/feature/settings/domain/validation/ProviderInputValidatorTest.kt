package com.djtech.monai.feature.settings.domain.validation

import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.settings.domain.model.AliasIssue
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.model.ProviderNameIssue
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ProviderInputValidatorTest {

    @Test
    fun `normalizes like the server stores it`() {
        val aliases = listOf(" Link Aja", "linkaja", "LINKAJA", " ")

        val normalized = input(name = "  LinkAja ", aliases = aliases).normalized()

        assertEquals("LinkAja", normalized.name)
        assertEquals(listOf("link aja", "linkaja"), normalized.aliases)
    }

    @Test
    fun `checks the name`() {
        assertEquals(ProviderNameIssue.REQUIRED, input(name = " ").normalized().nameIssue())
        assertEquals(ProviderNameIssue.TOO_LONG, input(name = "a".repeat(51)).nameIssue())
        assertNull(input(name = "a".repeat(50)).nameIssue())
    }

    @Test
    fun `checks the aliases`() {
        assertEquals(AliasIssue.TOO_MANY, input(aliases = (1..21).map { "a$it" }).aliasIssue())
        assertEquals(AliasIssue.TOO_LONG, input(aliases = listOf("a".repeat(51))).aliasIssue())
        assertNull(input(aliases = (1..20).map { "a$it" }).aliasIssue())
    }

    @Test
    fun `slugs follow the server`() {
        assertEquals("bank-bca", slugOf("Bank BCA"))
        assertEquals("go-pay", slugOf("  Go—Pay! "))
        assertEquals("", slugOf("!!!"))
        assertEquals(50, slugOf("a".repeat(60)).length)
    }

    private fun input(name: String = "LinkAja", aliases: List<String> = emptyList()) = ProviderInput(
        name = name,
        type = WalletType.E_WALLET,
        aliases = aliases,
        sortOrder = 100,
        isActive = true,
    )
}
