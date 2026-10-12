package com.djtech.monai.core.designsystem.icon

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.vector.ImageVector

/**
 * The icon for a category's Material Symbols name from the API (`restaurant`). Names without a
 * bundled icon, and categories without one, get the generic category icon.
 */
@Composable
fun categoryIcon(name: String?): ImageVector = when (name) {
    "restaurant" -> MonAIIcons.Restaurant
    "local_cafe" -> MonAIIcons.LocalCafe
    "directions_car" -> MonAIIcons.DirectionsCar
    "shopping_bag" -> MonAIIcons.ShoppingBag
    "receipt_long" -> MonAIIcons.ReceiptLong
    "favorite" -> MonAIIcons.Favorite
    "movie" -> MonAIIcons.Movie
    "payments" -> MonAIIcons.Payments
    "redeem" -> MonAIIcons.Redeem
    "savings" -> MonAIIcons.Savings
    "inventory_2" -> MonAIIcons.Inventory2
    "account_balance" -> MonAIIcons.AccountBalance
    else -> MonAIIcons.Category
}
