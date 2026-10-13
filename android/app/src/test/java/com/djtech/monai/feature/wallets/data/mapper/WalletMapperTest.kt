package com.djtech.monai.feature.wallets.data.mapper

import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.FieldError
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.wallets.data.dto.UpdateWalletRequestDto
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import org.junit.Assert.assertEquals
import org.junit.Test

class WalletMapperTest {

    @Test
    fun `offline is a network error and anything unparsed is unexpected`() {
        assertEquals(WalletError.Network, ApiError.Network.toWalletError())
        assertEquals(WalletError.Unexpected, ApiError.Unknown(IllegalStateException()).toWalletError())
    }

    @Test
    fun `business rule codes map to their errors`() {
        assertEquals(WalletError.NotFound, http(404, "not_found").toWalletError())
        assertEquals(WalletError.HasTransactions, http(422, "wallet_has_transactions").toWalletError())
        assertEquals(WalletError.DefaultRequired, http(422, "default_wallet_required").toWalletError())
        assertEquals(WalletError.Unexpected, http(500, "internal_error").toWalletError())
    }

    @Test
    fun `validation fields map to wallet fields by code`() {
        val error = http(
            422,
            "validation_failed",
            FieldError("name", "required", "is required"),
            FieldError("name", "max_length", "must be at most 30 characters"),
            FieldError("initial_balance", "max", "must be at most 999999999999999"),
            FieldError("initial_balance", "min", "must be at least 0"),
            FieldError("type", "one_of", "must be one of"),
            FieldError("color", "hexcolor", "must be a color"),
        )

        assertEquals(
            WalletError.InvalidFields(
                listOf(
                    WalletFieldError(WalletField.NAME, WalletFieldIssue.REQUIRED),
                    WalletFieldError(WalletField.NAME, WalletFieldIssue.TOO_LONG),
                    WalletFieldError(WalletField.INITIAL_BALANCE, WalletFieldIssue.TOO_LARGE),
                    WalletFieldError(WalletField.INITIAL_BALANCE, WalletFieldIssue.INVALID),
                    WalletFieldError(WalletField.TYPE, WalletFieldIssue.INVALID),
                    WalletFieldError(WalletField.COLOR, WalletFieldIssue.INVALID),
                ),
            ),
            error.toWalletError(),
        )
    }

    @Test
    fun `validation of fields the form doesn't show is unexpected`() {
        val error = http(422, "validation_failed", FieldError("provider_id", "invalid", "must be active"))

        assertEquals(WalletError.Unexpected, error.toWalletError())
    }

    @Test
    fun `a conflict on a request that sent a name means the name is taken`() {
        val taken = WalletError.InvalidFields(
            listOf(WalletFieldError(WalletField.NAME, WalletFieldIssue.ALREADY_EXISTS)),
        )

        assertEquals(taken, http(409, "conflict").toWalletError(nameSent = true))
        assertEquals(
            taken,
            http(409, "conflict", FieldError("name", "already_exists", "already exists")).toWalletError(),
        )
    }

    @Test
    fun `a conflict without a name, like two defaults at once, is unexpected`() {
        assertEquals(WalletError.Unexpected, http(409, "conflict").toWalletError(nameSent = false))
    }

    @Test
    fun `a create request carries every field and drops the slug`() {
        val request = WalletInput(
            providerId = "p-bca",
            providerSlug = "bca",
            name = "BCA",
            type = WalletType.BANK,
            initialBalance = 1_250_000,
            color = "#4A45D6",
            isDefault = true,
        ).toCreateRequest()

        assertEquals(
            """{"provider_id":"p-bca","name":"BCA","type":"BANK","initial_balance":1250000,""" +
                """"color":"#4A45D6","is_default":true}""",
            NetworkJson.encodeToString(request),
        )
    }

    @Test
    fun `an update request leaves out fields that didn't change`() {
        val request = WalletChanges(name = "Mandiri Bisnis", isArchived = true).toUpdateRequest()

        assertEquals(
            """{"name":"Mandiri Bisnis","is_archived":true}""",
            NetworkJson.encodeToString(UpdateWalletRequestDto.serializer(), request),
        )
    }

    private fun http(status: Int, code: String, vararg fields: FieldError) =
        ApiError.Http(status, code, "", fields.toList())
}
