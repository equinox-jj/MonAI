package com.djtech.monai.feature.categories.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.log.runLogged
import com.djtech.monai.core.common.result.flatMap
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.database.dao.CategoryDao
import com.djtech.monai.core.database.dao.TransactionDao
import com.djtech.monai.core.database.entity.CategoryEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.categories.data.dto.CategoryDto
import com.djtech.monai.feature.categories.data.mapper.asModel
import com.djtech.monai.feature.categories.data.mapper.toCategoryError
import com.djtech.monai.feature.categories.data.mapper.toCreateRequest
import com.djtech.monai.feature.categories.data.mapper.toUpdateRequest
import com.djtech.monai.feature.categories.data.remote.CategoryApiService
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryResult
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class CategoryRepositoryImpl @Inject constructor(
    private val categoryApiService: CategoryApiService,
    private val apiCaller: ApiCaller,
    private val categoryDao: CategoryDao,
    private val transactionDao: TransactionDao,
    private val errorLogger: ErrorLogger,
) : CategoryRepository {

    override fun observeCategories(): Flow<List<Category>> =
        categoryDao.observeAll().map { entities -> entities.map(CategoryEntity::asModel) }

    override fun observeVisibleCategories(type: CategoryType): Flow<List<Category>> =
        categoryDao.observeByType(type).map { entities ->
            entities.filterNot(CategoryEntity::isHidden).map(CategoryEntity::asModel)
        }

    // Hidden categories too: transactions that use them still need their name and icon.
    // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
    override suspend fun refresh(): CategoryResult<Unit> =
        apiCaller.callRaw { categoryApiService.getCategories(includeHidden = true).data.map(CategoryDto::asModel) }
            .mapError(ApiError::toCategoryError)
            .flatMap { categories ->
                errorLogger.runLogged("Caching categories failed", CategoryError.Unexpected) {
                    categoryDao.replaceAll(categories.map(Category::asEntity))
                }
            }

    // A change made on the server but not cached fails with Unexpected; the next refresh brings it in.
    override suspend fun createCategory(input: CategoryInput): CategoryResult<Category> {
        val body = input.toCreateRequest()
        return apiCaller.callRaw { categoryApiService.createCategory(body).data.asModel() }
            .mapError(ApiError::toCategoryError)
            .flatMap { category ->
                errorLogger.runLogged("Caching the created category failed", CategoryError.Unexpected) {
                    categoryDao.upsertAll(listOf(category.asEntity()))
                    category
                }
            }
    }

    override suspend fun updateCategory(id: String, changes: CategoryChanges): CategoryResult<Category> {
        val body = changes.toUpdateRequest()
        return apiCaller.callRaw { categoryApiService.updateCategory(id, body).data.asModel() }
            .mapError(ApiError::toCategoryError)
            .flatMap { category ->
                errorLogger.runLogged("Caching the updated category failed", CategoryError.Unexpected) {
                    categoryDao.upsertAll(listOf(category.asEntity()))
                    category
                }
            }
    }

    override suspend fun deleteCategory(id: String, moveTo: String?): CategoryResult<Unit> =
        apiCaller.callRaw { categoryApiService.deleteCategory(id, moveTo) }
            .mapError(ApiError::toCategoryError)
            .flatMap {
                errorLogger.runLogged("Removing the deleted category from the cache failed", CategoryError.Unexpected) {
                    // No foreign keys: the cached transactions follow the server's move by hand.
                    if (moveTo != null) transactionDao.moveCategory(from = id, to = moveTo)
                    categoryDao.delete(id)
                }
            }
}
