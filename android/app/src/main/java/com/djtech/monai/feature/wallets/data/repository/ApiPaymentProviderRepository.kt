package com.djtech.monai.feature.wallets.data.repository

import com.djtech.monai.core.common.coroutines.Dispatcher
import com.djtech.monai.core.common.coroutines.MonAIDispatcher
import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.log.runLogged
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.catching
import com.djtech.monai.core.common.result.flatMap
import com.djtech.monai.core.common.result.getOrElse
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.database.dao.PaymentProviderDao
import com.djtech.monai.core.database.entity.PaymentProviderCatalogEntity
import com.djtech.monai.core.database.entity.PaymentProviderEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.PaymentProviderCatalog
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.wallets.data.dto.SeedPaymentProviderDto
import com.djtech.monai.feature.wallets.data.mapper.asModel
import com.djtech.monai.feature.wallets.data.mapper.toWalletError
import com.djtech.monai.feature.wallets.data.remote.PaymentProviderApiService
import com.djtech.monai.feature.wallets.data.seed.PaymentProviderSeed
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.PaymentProviderRepository
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.withContext
import retrofit2.HttpException
import java.net.HttpURLConnection.HTTP_NOT_MODIFIED
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ApiPaymentProviderRepository @Inject constructor(
    private val paymentProviderApiService: PaymentProviderApiService,
    private val apiCaller: ApiCaller,
    private val paymentProviderDao: PaymentProviderDao,
    private val seed: PaymentProviderSeed,
    private val errorLogger: ErrorLogger,
    @Dispatcher(MonAIDispatcher.IO) private val ioDispatcher: CoroutineDispatcher,
) : PaymentProviderRepository {

    private val seedLock = Mutex()
    private var seedProviders: List<PaymentProvider>? = null

    override fun observeProviders(): Flow<List<PaymentProvider>> = paymentProviderDao.observeAll().map { entities ->
        if (entities.isEmpty()) seedProviders() else entities.map(PaymentProviderEntity::asModel)
    }

    override suspend fun refresh(): WalletResult<Unit> {
        // The ETag only stands for the cached providers; without any, ask for the full catalog.
        val etag = catching {
            paymentProviderDao.catalogMeta()?.etag?.takeIf { paymentProviderDao.observeAll().first().isNotEmpty() }
        }.getOrElse { e ->
            errorLogger.log("Reading the provider catalog version failed", e)
            null
        }
        val result = apiCaller.callRaw {
            val response = paymentProviderApiService.getCatalog(etag)
            when {
                response.code() == HTTP_NOT_MODIFIED -> null
                // Thrown so ApiCaller maps the error body like any other HTTP failure.
                !response.isSuccessful -> throw HttpException(response)
                else -> CatalogUpdate(
                    catalog = checkNotNull(response.body()) { "Empty provider catalog" }.data.asModel(),
                    etag = response.headers()["ETag"],
                )
            }
        }
        // No update means 304: the cached catalog is current.
        return result.mapError(ApiError::toWalletError).flatMap { update ->
            if (update == null) Outcome.Success(Unit) else cache(update)
        }
    }

    private suspend fun cache(update: CatalogUpdate): WalletResult<Unit> =
        errorLogger.runLogged("Caching the provider catalog failed", WalletError.Unexpected) {
            paymentProviderDao.replaceCatalog(
                meta = PaymentProviderCatalogEntity(version = update.catalog.version, etag = update.etag),
                providers = update.catalog.providers.map(PaymentProvider::asEntity),
            )
        }

    // Parsed once and kept: it only matters until the first refresh fills the cache.
    private suspend fun seedProviders(): List<PaymentProvider> = seedLock.withLock {
        seedProviders ?: withContext(ioDispatcher) { readSeed() }.also { seedProviders = it }
    }

    private fun readSeed(): List<PaymentProvider> = catching {
        NetworkJson.decodeFromString<List<SeedPaymentProviderDto>>(seed.read())
            .map(SeedPaymentProviderDto::asModel)
            .sortedWith(compareBy<PaymentProvider> { it.sortOrder }.thenBy(String.CASE_INSENSITIVE_ORDER) { it.name })
    }.getOrElse { e ->
        errorLogger.log("Reading the bundled provider catalog failed", e)
        emptyList()
    }

    private data class CatalogUpdate(val catalog: PaymentProviderCatalog, val etag: String?)
}
