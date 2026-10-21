import 'package:monai/core/ui/l10n/l10n.dart';

/// Spoken names of the form's icons and colors.
extension CategoryChoiceText on AppLocalizations {
  /// The name of a Material Symbols [icon] from the icon grid.
  String categoryIconName(String icon) => switch (icon) {
    'local_cafe' => categoryIconLocalCafe,
    'restaurant' => categoryIconRestaurant,
    'lunch_dining' => categoryIconLunchDining,
    'local_grocery_store' => categoryIconLocalGroceryStore,
    'directions_car' => categoryIconDirectionsCar,
    'two_wheeler' => categoryIconTwoWheeler,
    'receipt_long' => categoryIconReceiptLong,
    'bolt' => categoryIconBolt,
    'shopping_bag' => categoryIconShoppingBag,
    'checkroom' => categoryIconCheckroom,
    'favorite' => categoryIconFavorite,
    'fitness_center' => categoryIconFitnessCenter,
    'movie' => categoryIconMovie,
    'sports_esports' => categoryIconSportsEsports,
    'school' => categoryIconSchool,
    'pets' => categoryIconPets,
    'home' => categoryIconHome,
    _ => categoryIconCategory,
  };

  /// The name of a `#RRGGBB` [color] from the swatches.
  String categoryColorName(String color) => switch (color) {
    '#F97316' => categoryColorOrange,
    '#0EA5E9' => categoryColorSky,
    '#EC4899' => categoryColorPink,
    '#8B5CF6' => categoryColorViolet,
    '#10B981' => categoryColorEmerald,
    '#F59E0B' => categoryColorAmber,
    '#6366F1' => categoryColorIndigo,
    '#84CC16' => categoryColorLime,
    '#14B8A6' => categoryColorTeal,
    _ => categoryColorSlate,
  };
}
