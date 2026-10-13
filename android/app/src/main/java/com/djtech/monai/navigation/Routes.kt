package com.djtech.monai.navigation

import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import kotlinx.serialization.Serializable

// Keys are @Serializable so rememberNavBackStack can restore them after process death.

@Serializable
data object WelcomeRoute : NavKey

/** [email] is the one typed on Sign in, so the form doesn't start empty. */
@Serializable
data class RegisterRoute(val email: String = "") : NavKey

/** [email] is the one typed on Register, e.g. after "already has an account". */
@Serializable
data class SignInRoute(val email: String = "") : NavKey

@Serializable
data object HomeRoute : NavKey

@Serializable
data object TransactionsRoute : NavKey

@Serializable
data object WalletsRoute : NavKey

@Serializable
data object SettingsRoute : NavKey

@Serializable
data class WalletDetailRoute(val id: String) : NavKey

/** [id] is the wallet to edit; null adds one. */
@Serializable
data class WalletFormRoute(val id: String? = null) : NavKey

@Serializable
data object ArchivedWalletsRoute : NavKey

@Serializable
data class TransactionDetailRoute(val id: String) : NavKey

/**
 * [id] is the transaction to edit; null adds one, starting as [presetType] (expense when null)
 * from [presetWalletId] (the default wallet when null), or filled from a quick-add [draft].
 */
@Serializable
data class TransactionFormRoute(
    val id: String? = null,
    val presetType: TransactionType? = null,
    val presetWalletId: String? = null,
    val draft: DraftKey? = null,
) : NavKey

@Serializable
data object QuickAddRoute : NavKey

/** Several [drafts] read from one quick-add [phrase], reviewed one by one. */
@Serializable
data class QuickAddReviewRoute(val phrase: String, val drafts: List<DraftKey>) : NavKey

@Serializable
data object ScanReceiptRoute : NavKey

/** The [draft] read from the photo at [photoUri]; [aiFailed] when the AI couldn't, so it is empty. */
@Serializable
data class ReceiptReviewRoute(val photoUri: String, val draft: ReceiptDraftKey, val aiFailed: Boolean) : NavKey

/** [month] is `YYYY-MM`, the month to search first; null for the current one. */
@Serializable
data class TransactionSearchRoute(val month: String? = null) : NavKey

/** [month] is `YYYY-MM`, the month whose budget to set or change. */
@Serializable
data class BudgetRoute(val month: String) : NavKey

/** [month] is `YYYY-MM`, the month to open on; null for the current one. */
@Serializable
data class ReportRoute(val month: String? = null) : NavKey

/** A new custom category of [type], or the one with [id] to edit. */
@Serializable
data class CategoryFormRoute(val type: CategoryType, val id: String? = null) : NavKey

/** [focusDelete] scrolls to the delete-account card. */
@Serializable
data class EditProfileRoute(val focusDelete: Boolean = false) : NavKey

@Serializable
data object CategoriesRoute : NavKey

@Serializable
data object ManageProvidersRoute : NavKey

/** [id] is the payment provider to edit; null adds one. */
@Serializable
data class ProviderFormRoute(val id: String? = null) : NavKey

/** Screens that take the whole window on a phone, so the bottom bar hides under them. */
internal fun NavKey.isFullScreen(): Boolean = when (this) {
    is TransactionDetailRoute,
    is TransactionFormRoute,
    QuickAddRoute,
    is QuickAddReviewRoute,
    ScanReceiptRoute,
    is ReceiptReviewRoute,
    is TransactionSearchRoute,
    is WalletDetailRoute,
    is WalletFormRoute,
    ArchivedWalletsRoute,
    is BudgetRoute,
    is ReportRoute,
    is CategoryFormRoute,
    is EditProfileRoute,
    CategoriesRoute,
    ManageProvidersRoute,
    is ProviderFormRoute,
        -> true

    else -> false
}
