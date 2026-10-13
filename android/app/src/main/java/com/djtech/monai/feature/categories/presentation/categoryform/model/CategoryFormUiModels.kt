package com.djtech.monai.feature.categories.presentation.categoryform.model

import androidx.annotation.StringRes
import com.djtech.monai.R

/** An icon the form offers: its Material Symbols name, which the API stores, and its spoken label. */
enum class CategoryIconChoice(val symbol: String, @StringRes val label: Int) {
    Coffee("local_cafe", R.string.category_icon_coffee),
    Restaurant("restaurant", R.string.category_icon_restaurant),
    Meal("lunch_dining", R.string.category_icon_meal),
    Groceries("local_grocery_store", R.string.category_icon_groceries),
    Car("directions_car", R.string.category_icon_car),
    Motorbike("two_wheeler", R.string.category_icon_motorbike),
    Bills("receipt_long", R.string.category_icon_bills),
    Electricity("bolt", R.string.category_icon_electricity),
    Shopping("shopping_bag", R.string.category_icon_shopping),
    Clothes("checkroom", R.string.category_icon_clothes),
    Health("favorite", R.string.category_icon_health),
    Fitness("fitness_center", R.string.category_icon_fitness),
    Movies("movie", R.string.category_icon_movies),
    Games("sports_esports", R.string.category_icon_games),
    Education("school", R.string.category_icon_education),
    Pets("pets", R.string.category_icon_pets),
    Home("home", R.string.category_icon_home),
    Other("category", R.string.category_icon_other),
}

/** A color the form offers: the light hex the API stores, and its spoken name. */
enum class CategoryColorChoice(val hex: String, @StringRes val label: Int) {
    Orange("#F97316", R.string.category_color_orange),
    Sky("#0EA5E9", R.string.category_color_sky),
    Pink("#EC4899", R.string.category_color_pink),
    Violet("#8B5CF6", R.string.category_color_violet),
    Emerald("#10B981", R.string.category_color_emerald),
    Amber("#F59E0B", R.string.category_color_amber),
    Indigo("#6366F1", R.string.category_color_indigo),
    Lime("#84CC16", R.string.category_color_lime),
    Teal("#14B8A6", R.string.category_color_teal),
    Slate("#64748B", R.string.category_color_slate),
}
