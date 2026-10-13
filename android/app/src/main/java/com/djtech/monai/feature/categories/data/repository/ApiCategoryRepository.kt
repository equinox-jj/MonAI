package com.djtech.monai.feature.categories.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.dao.CategoryDao
import com.djtech.monai.core.database.entity.CategoryEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.feature.categories.data.dto.CategoryDto
import com.djtech.monai.feature.categories.data.mapper.asModel
import com.djtech.monai.feature.categories.data.mapper.toCategoryError
import com.djtech.monai.feature.categories.data.mapper.toCreateRequest
import com.djtech.monai.feature.categories.data.remote.CategoryApiService
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryResult
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.cancellation.CancellationException

@Singleton
class ApiCategoryRepository @Inject constructor(
    private val categoryApiService: CategoryApiService,
    private val apiCaller: ApiCaller,
    private val categoryDao: CategoryDao,
    private val errorLogger: ErrorLogger,
) : CategoryRepository {

    override fun observeCategories(): Flow<List<Category>> =
        categoryDao.observeAll().map { entities -> entities.map(CategoryEntity::asModel) }

    override fun observeVisibleCategories(type: CategoryType): Flow<List<Category>> =
        categoryDao.observeByType(type).map { entities ->
            entities.filterNot(CategoryEntity::isHidden).map(CategoryEntity::asModel)
        }

    override suspend fun refresh(): CategoryResult<Unit> {
        // Hidden categories too: transactions that use them still need their name and icon.
        // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
        val result = apiCaller.callRaw {
            categoryApiService.getCategories(includeHidden = true).data.map(CategoryDto::asModel)
        }
        return when (result) {
            is Outcome.Success -> cache(result.data)
            is Outcome.Failure -> Outcome.Failure(result.error.toCategoryError())
        }
    }

    override suspend fun createCategory(input: CategoryInput): CategoryResult<Category> {
        val body = input.toCreateRequest()
        // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
        val result = apiCaller.callRaw { categoryApiService.createCategory(body).data.asModel() }
        return when (result) {
            is Outcome.Success -> {
                val category = result.data
                try {
                    categoryDao.upsertAll(listOf(category.asEntity()))
                } catch (e: CancellationException) {
                    throw e
                } catch (e: Exception) {
                    // Created on the server but not cached; the next refresh brings it in.
                    errorLogger.log("Caching the created category failed", e)
                    return Outcome.Failure(CategoryError.Unexpected)
                }
                Outcome.Success(category)
            }

            is Outcome.Failure -> Outcome.Failure(result.error.toCategoryError())
        }
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private suspend fun cache(categories: List<Category>): CategoryResult<Unit> = try {
        categoryDao.replaceAll(categories.map(Category::asEntity))
        Outcome.Success(Unit)
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Caching categories failed", e)
        Outcome.Failure(CategoryError.Unexpected)
    }
}
