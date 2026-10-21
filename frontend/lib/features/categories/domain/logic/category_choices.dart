/// Material Symbols names, in the form's order. The last, `category`, is the
/// fallback.
const categoryIconChoices = [
  'local_cafe',
  'restaurant',
  'lunch_dining',
  'local_grocery_store',
  'directions_car',
  'two_wheeler',
  'receipt_long',
  'bolt',
  'shopping_bag',
  'checkroom',
  'favorite',
  'fitness_center',
  'movie',
  'sports_esports',
  'school',
  'pets',
  'home',
  'category',
];

/// `#RRGGBB`, in the form's order.
const categoryColorChoices = [
  '#F97316',
  '#0EA5E9',
  '#EC4899',
  '#8B5CF6',
  '#10B981',
  '#F59E0B',
  '#6366F1',
  '#84CC16',
  '#14B8A6',
  '#64748B',
];

const defaultCategoryIcon = 'local_cafe';
const defaultCategoryColor = '#F97316';

String categoryIconChoice(String? icon) =>
    categoryIconChoices.contains(icon) ? icon! : categoryIconChoices.last;

String categoryColorChoice(String? color) {
  final upper = color?.toUpperCase();
  return categoryColorChoices.contains(upper)
      ? upper!
      : categoryColorChoices.first;
}
