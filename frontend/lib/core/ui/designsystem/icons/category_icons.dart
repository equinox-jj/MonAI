import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';

/// Category icon names the API can send (Material Symbols names) mapped to
/// the bundled icons.
const _categoryIcons = {
  'restaurant': MonAIIcons.restaurant,
  'local_cafe': MonAIIcons.localCafe,
  'directions_car': MonAIIcons.directionsCar,
  'shopping_bag': MonAIIcons.shoppingBag,
  'receipt_long': MonAIIcons.receiptLong,
  'favorite': MonAIIcons.favorite,
  'movie': MonAIIcons.movie,
  'payments': MonAIIcons.payments,
  'redeem': MonAIIcons.redeem,
  'savings': MonAIIcons.savings,
  'inventory_2': MonAIIcons.inventory2,
  'account_balance': MonAIIcons.accountBalance,
  'work': MonAIIcons.work,
  'lunch_dining': MonAIIcons.lunchDining,
  'local_grocery_store': MonAIIcons.localGroceryStore,
  'two_wheeler': MonAIIcons.twoWheeler,
  'bolt': MonAIIcons.bolt,
  'checkroom': MonAIIcons.checkroom,
  'fitness_center': MonAIIcons.fitnessCenter,
  'sports_esports': MonAIIcons.sportsEsports,
  'school': MonAIIcons.school,
  'pets': MonAIIcons.pets,
  'home': MonAIIcons.home,
};

/// The icon for a category's Material Symbols [name] from the API
/// (`restaurant`). Names without a bundled icon, and null, get the generic
/// category icon.
MonAIIconData categoryIcon(String? name) =>
    _categoryIcons[name] ?? MonAIIcons.category;
