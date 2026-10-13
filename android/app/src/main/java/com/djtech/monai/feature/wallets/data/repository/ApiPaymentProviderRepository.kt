package com.djtech.monai.feature.wallets.data.repository

import com.djtech.monai.core.common.dispatcher.Dispatcher
import com.djtech.monai.core.common.dispatcher.MonAIDispatcher
import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.dao.PaymentProviderDao
import com.djtech.monai.core.database.entity.PaymentProviderCatalogEntity
import com.djtech.monai.core.database.entity.PaymentProviderEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.PaymentProviderCatalog
import com.djtech.monai.core.network.ApiCaller
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
import kotlin.coroutines.cancellation.CancellationException

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
        val etag = try {
            paymentProviderDao.catalogMeta()?.etag?.takeIf { paymentProviderDao.observeAll().first().isNotEmpty() }
        } catch (e: CancellationException) {
            throw e
        } catch (e: Exception) {
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
        return when (result) {
            is Outcome.Failure -> Outcome.Failure(result.error.toWalletError())
            is Outcome.Success -> result.data?.let { cache(it) } ?: Outcome.Success(Unit)
        }
    }

    private suspend fun cache(update: CatalogUpdate): WalletResult<Unit> = try {
        paymentProviderDao.replaceCatalog(
            meta = PaymentProviderCatalogEntity(version = update.catalog.version, etag = update.etag),
            providers = update.catalog.providers.map(PaymentProvider::asEntity),
        )
        Outcome.Success(Unit)
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Caching the provider catalog failed", e)
        Outcome.Failure(WalletError.Unexpected)
    }

    // Parsed once and kept: it only matters until the first refresh fills the cache.
    private suspend fun seedProviders(): List<PaymentProvider> = seedLock.withLock {
        seedProviders ?: withContext(ioDispatcher) { readSeed() }.also { seedProviders = it }
    }

    private fun readSeed(): List<PaymentProvider> = try {
        NetworkJson.decodeFromString<List<SeedPaymentProviderDto>>(seed.read())
            .map(SeedPaymentProviderDto::asModel)
            .sortedWith(compareBy<PaymentProvider> { it.sortOrder }.thenBy(String.CASE_INSENSITIVE_ORDER) { it.name })
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Reading the bundled provider catalog failed", e)
        emptyList()
    }

    private data class CatalogUpdate(val catalog: PaymentProviderCatalog, val etag: String?)
}
