package com.djtech.monai.core.network

import kotlinx.serialization.json.Json

/** JSON settings shared by Retrofit and error-body parsing. */
val NetworkJson = Json {
    ignoreUnknownKeys = true
    explicitNulls = false
}
