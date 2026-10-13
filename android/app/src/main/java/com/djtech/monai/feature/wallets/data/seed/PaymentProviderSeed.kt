package com.djtech.monai.feature.wallets.data.seed

import android.content.Context
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject

/** The raw JSON of the provider catalog bundled with the app, shown before the first refresh. */
fun interface PaymentProviderSeed {
    fun read(): String
}

/** Reads the seed from `assets/payment_providers_seed.json`. Blocking; call it off the main thread. */
class AssetPaymentProviderSeed @Inject constructor(
    @ApplicationContext private val context: Context,
) : PaymentProviderSeed {
    override fun read(): String = context.assets.open(SEED_ASSET).bufferedReader().use { it.readText() }

    private companion object {
        const val SEED_ASSET = "payment_providers_seed.json"
    }
}
