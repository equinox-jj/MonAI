package com.djtech.monai.feature.quickadd.domain.usecase

import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.usecase.ObserveVisibleCategoriesUseCase
import com.djtech.monai.feature.quickadd.domain.parser.ParseContext
import com.djtech.monai.feature.wallets.domain.usecase.ObservePaymentProvidersUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import javax.inject.Inject

/** What the phone-side parser matches: active wallets, visible categories of both types, provider aliases. */
class ObserveQuickAddContextUseCase @Inject constructor(
    private val observeWallets: ObserveWalletsUseCase,
    private val observeVisibleCategories: ObserveVisibleCategoriesUseCase,
    private val observePaymentProviders: ObservePaymentProvidersUseCase,
    private val clock: AppClock,
) {
    operator fun invoke(): Flow<ParseContext> = combine(
        observeWallets(),
        observeVisibleCategories(CategoryType.EXPENSE),
        observeVisibleCategories(CategoryType.INCOME),
        observePaymentProviders(),
    ) { wallets, expense, income, providers ->
        ParseContext(wallets, expense + income, providers, clock.today())
    }
}
