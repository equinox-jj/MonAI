package com.djtech.monai.feature.categories.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakeCategoryDao
import com.djtech.monai.core.database.FakeTransactionDao
import com.djtech.monai.core.database.entity.CategoryEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.categories.data.remote.CategoryApiService
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryNameIssue
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertSame
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.io.IOException
import java.time.Instant

class CategoryRepositoryImplTest {

    private val errorLogger = RecordingErrorLogger()
    private val server = MockWebServer()

    @Before
    fun setUp() {
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
    }

    @Test
    fun `refresh asks for hidden categories of every type and caches every field`() = runTest {
        val dao = FakeCategoryDao()
        server.enqueue(MockResponse(code = 200, body = categoriesBody(FOOD_JSON, SALARY_JSON)))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("GET", request.method)
        assertEquals("/api/v1/categories", request.url.encodedPath)
        assertEquals("true", request.url.queryParameter("include_hidden"))
        assertNull(request.url.queryParameter("type"))
        assertEquals(listOf(FOOD, SALARY), dao.categories.map { it.asModel() })
    }

    @Test
    fun `refresh drops categories the server no longer returns`() = runTest {
        val dao = FakeCategoryDao(listOf(entity(id = "stale", name = "Deleted")))
        server.enqueue(MockResponse(code = 200, body = categoriesBody(FOOD_JSON)))

        repository(dao).refresh()

        assertEquals(listOf(FOOD.id), dao.categories.map { it.id })
    }

    @Test
    fun `observeCategories includes hidden categories so old transactions keep their label`() = runTest {
        val dao = FakeCategoryDao(
            listOf(
                entity(id = "a", name = "Transport"),
                entity(id = "b", name = "bills", isHidden = true),
                entity(id = "c", name = "Salary", type = CategoryType.INCOME),
            ),
        )

        val categories = repository(dao).observeCategories().first()

        assertEquals(listOf("b", "c", "a"), categories.map(Category::id))
    }

    @Test
    fun `observeVisibleCategories keeps one type and leaves out hidden ones`() = runTest {
        val dao = FakeCategoryDao(
            listOf(
                entity(id = "a", name = "Transport"),
                entity(id = "b", name = "Bills", isHidden = true),
                entity(id = "c", name = "Salary", type = CategoryType.INCOME),
                entity(id = "d", name = "Food"),
            ),
        )

        val categories = repository(dao).observeVisibleCategories(CategoryType.EXPENSE).first()

        assertEquals(listOf("d", "a"), categories.map(Category::id))
    }

    @Test
    fun `refresh offline fails with a network error and keeps the cache`() = runTest {
        val cached = entity(id = "a", name = "Food")
        val dao = FakeCategoryDao(listOf(cached))
        val repository = repository(dao)
        server.close()

        val result = repository.refresh()

        assertEquals(Outcome.Failure(CategoryError.Network), result)
        assertEquals(listOf(cached), dao.categories)
    }

    @Test
    fun `refresh fails as unexpected on a server error and keeps the cache`() = runTest {
        val cached = entity(id = "a", name = "Food")
        val dao = FakeCategoryDao(listOf(cached))
        server.enqueue(
            MockResponse(
                code = 500,
                body = """{"success":false,"message":"Failed","data":null,"error":{"code":"internal_error"}}""",
            ),
        )

        val result = repository(dao).refresh()

        assertEquals(Outcome.Failure(CategoryError.Unexpected), result)
        assertEquals(listOf(cached), dao.categories)
    }

    @Test
    fun `refresh fails as unexpected when the body does not parse and keeps the cache`() = runTest {
        val cached = entity(id = "a", name = "Food")
        val dao = FakeCategoryDao(listOf(cached))
        server.enqueue(MockResponse(code = 200, body = """{"success":true,"message":"OK","data":[{"id":"x"}]}"""))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Failure(CategoryError.Unexpected), result)
        assertEquals(listOf(cached), dao.categories)
    }

    @Test
    fun `refresh fails as unexpected when a date does not parse and keeps the cache`() = runTest {
        val cached = entity(id = "a", name = "Food")
        val dao = FakeCategoryDao(listOf(cached))
        val badDate = FOOD_JSON.replace("2026-10-11T08:15:30Z", "yesterday")
        server.enqueue(MockResponse(code = 200, body = categoriesBody(badDate)))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Failure(CategoryError.Unexpected), result)
        assertEquals(listOf(cached), dao.categories)
    }

    @Test
    fun `refresh fails as unexpected and logs when the cache cannot be written`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeCategoryDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 200, body = categoriesBody(FOOD_JSON)))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Failure(CategoryError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    @Test
    fun `createCategory posts the input and caches the created category`() = runTest {
        val dao = FakeCategoryDao()
        server.enqueue(MockResponse(code = 201, body = categoryBody(FOOD_JSON)))

        val result = repository(dao).createCategory(FOOD_INPUT)

        assertEquals(Outcome.Success(FOOD), result)
        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals("/api/v1/categories", request.url.encodedPath)
        assertEquals(
            """{"name":"Food","type":"EXPENSE","icon":"restaurant","color":"#F97316"}""",
            request.body?.utf8(),
        )
        assertEquals(listOf(FOOD), dao.categories.map { it.asModel() })
    }

    @Test
    fun `createCategory leaves out an icon and color it doesn't have`() = runTest {
        server.enqueue(MockResponse(code = 201, body = categoryBody(FOOD_JSON)))

        repository(FakeCategoryDao()).createCategory(FOOD_INPUT.copy(icon = null, color = null))

        assertEquals("""{"name":"Food","type":"EXPENSE"}""", server.takeRequest().body?.utf8())
    }

    @Test
    fun `createCategory with a name already in use fails with a taken name`() = runTest {
        server.enqueue(errorResponse(status = 409, code = "conflict"))

        val result = repository(FakeCategoryDao()).createCategory(FOOD_INPUT)

        assertEquals(Outcome.Failure(CategoryError.InvalidName(CategoryNameIssue.ALREADY_EXISTS)), result)
    }

    @Test
    fun `createCategory with a name the server rejects says why`() = runTest {
        server.enqueue(
            MockResponse(
                code = 422,
                body = """{"success":false,"message":"Failed","data":null,"error":{"code":"validation_failed",""" +
                    """"fields":[{"field":"name","code":"max_length","message":"too long"}]}}""",
            ),
        )

        val result = repository(FakeCategoryDao()).createCategory(FOOD_INPUT)

        assertEquals(Outcome.Failure(CategoryError.InvalidName(CategoryNameIssue.TOO_LONG)), result)
    }

    @Test
    fun `createCategory offline fails with a network error and caches nothing`() = runTest {
        val dao = FakeCategoryDao()
        val repository = repository(dao)
        server.close()

        val result = repository.createCategory(FOOD_INPUT)

        assertEquals(Outcome.Failure(CategoryError.Network), result)
        assertEquals(emptyList<CategoryEntity>(), dao.categories)
    }

    @Test
    fun `createCategory fails as unexpected and logs when the category cannot be cached`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeCategoryDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 201, body = categoryBody(FOOD_JSON)))

        val result = repository(dao).createCategory(FOOD_INPUT)

        assertEquals(Outcome.Failure(CategoryError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    @Test
    fun `updateCategory patches only the given fields and caches the result`() = runTest {
        val dao = FakeCategoryDao(listOf(FOOD.copy(isHidden = false).asEntity()))
        server.enqueue(MockResponse(code = 200, body = categoryBody(FOOD_JSON)))

        val result = repository(dao).updateCategory(FOOD.id, CategoryChanges(isHidden = true))

        assertEquals(Outcome.Success(FOOD), result)
        val request = server.takeRequest()
        assertEquals("PATCH", request.method)
        assertEquals("/api/v1/categories/${FOOD.id}", request.url.encodedPath)
        assertEquals("""{"is_hidden":true}""", request.body?.utf8())
        assertEquals(listOf(FOOD), dao.categories.map { it.asModel() })
    }

    @Test
    fun `hiding a system category is locked`() = runTest {
        server.enqueue(errorResponse(422, "system_category_locked"))

        val result = repository(FakeCategoryDao()).updateCategory("other", CategoryChanges(isHidden = true))

        assertEquals(Outcome.Failure(CategoryError.Locked), result)
    }

    @Test
    fun `deleteCategory removes it from the cache`() = runTest {
        val dao = FakeCategoryDao(listOf(FOOD.asEntity(), entity(id = "kopi", name = "Kopi")))
        server.enqueue(MockResponse(code = 200, body = DELETED))

        val result = repository(dao).deleteCategory("kopi", moveTo = null)

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("DELETE", request.method)
        assertEquals("/api/v1/categories/kopi", request.url.encodedPath)
        assertNull(request.url.queryParameter("move_to"))
        assertEquals(listOf(FOOD.id), dao.categories.map { it.id })
    }

    @Test
    fun `deleteCategory with a target moves the cached transactions too`() = runTest {
        val transactions = FakeTransactionDao(
            listOf(
                transaction("t1", categoryId = "kopi").asEntity(),
                transaction("t2", categoryId = "food").asEntity(),
            ),
        )
        server.enqueue(MockResponse(code = 200, body = DELETED))

        val result = repository(FakeCategoryDao(), transactions).deleteCategory("kopi", moveTo = "other")

        assertEquals(Outcome.Success(Unit), result)
        assertEquals("other", server.takeRequest().url.queryParameter("move_to"))
        assertEquals(
            mapOf("t1" to "other", "t2" to "food"),
            transactions.transactions.associate { it.id to it.categoryId },
        )
    }

    @Test
    fun `deleteCategory in use without a target needs one`() = runTest {
        val dao = FakeCategoryDao(listOf(entity(id = "kopi", name = "Kopi")))
        server.enqueue(errorResponse(422, "category_has_transactions"))

        val result = repository(dao).deleteCategory("kopi", moveTo = null)

        assertEquals(Outcome.Failure(CategoryError.HasTransactions), result)
        assertEquals(listOf("kopi"), dao.categories.map { it.id })
    }

    private fun repository(
        dao: FakeCategoryDao,
        transactionDao: FakeTransactionDao = FakeTransactionDao(),
    ): CategoryRepositoryImpl {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(CategoryApiService::class.java)
        return CategoryRepositoryImpl(
            categoryApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            categoryDao = dao,
            transactionDao = transactionDao,
            errorLogger = errorLogger,
        )
    }

    private fun categoryBody(category: String) = """{"success":true,"message":"Created","data":$category}"""

    private fun errorResponse(status: Int, code: String) = MockResponse(
        code = status,
        body = """{"success":false,"message":"Failed","data":null,"error":{"code":"$code"}}""",
    )

    private fun categoriesBody(vararg categories: String) =
        """{"success":true,"message":"OK","data":[${categories.joinToString(",")}]}"""

    private fun entity(
        id: String,
        name: String,
        type: CategoryType = CategoryType.EXPENSE,
        isHidden: Boolean = false,
    ) = CategoryEntity(
        id = id,
        name = name,
        type = type,
        icon = null,
        color = null,
        isDefault = false,
        isSystem = false,
        isHidden = isHidden,
        createdAt = CREATED_AT,
        updatedAt = CREATED_AT,
    )

    private companion object {
        val CREATED_AT: Instant = Instant.parse("2026-10-01T03:00:00Z")

        val FOOD = Category(
            id = "3d2c1b0a-9f8e-4d7c-6b5a-4f3e2d1c0b9a",
            name = "Food",
            type = CategoryType.EXPENSE,
            icon = "restaurant",
            color = "#F97316",
            isDefault = true,
            isSystem = false,
            isHidden = true,
            createdAt = CREATED_AT,
            updatedAt = Instant.parse("2026-10-11T08:15:30Z"),
        )

        val FOOD_INPUT = CategoryInput(
            name = "Food",
            type = CategoryType.EXPENSE,
            icon = "restaurant",
            color = "#F97316",
        )

        val SALARY = Category(
            id = "7a6b5c4d-3e2f-4a1b-9c8d-7e6f5a4b3c2d",
            name = "Salary",
            type = CategoryType.INCOME,
            icon = null,
            color = null,
            isDefault = false,
            isSystem = true,
            isHidden = false,
            createdAt = CREATED_AT,
            updatedAt = CREATED_AT,
        )

        const val DELETED = """{"success":true,"message":"Deleted","data":null}"""

        val FOOD_JSON = """
            {
              "id": "3d2c1b0a-9f8e-4d7c-6b5a-4f3e2d1c0b9a",
              "name": "Food",
              "type": "EXPENSE",
              "icon": "restaurant",
              "color": "#F97316",
              "is_default": true,
              "is_system": false,
              "is_hidden": true,
              "created_at": "2026-10-01T03:00:00Z",
              "updated_at": "2026-10-11T08:15:30Z"
            }
        """.trimIndent()

        val SALARY_JSON = """
            {
              "id": "7a6b5c4d-3e2f-4a1b-9c8d-7e6f5a4b3c2d",
              "name": "Salary",
              "type": "INCOME",
              "icon": null,
              "color": null,
              "is_default": false,
              "is_system": true,
              "is_hidden": false,
              "created_at": "2026-10-01T03:00:00Z",
              "updated_at": "2026-10-01T03:00:00Z"
            }
        """.trimIndent()
    }
}
