import 'package:monai/features/shared/domain/entity/category.dart';

/// What a category is, which decides what the user may do with it.
enum CategoryKind {
  /// Seeded for every user: can be hidden, not deleted.
  standard,

  /// Made by the user: can be deleted, and shown again once hidden.
  custom,

  /// "Other": always kept so every transaction has a category.
  system;

  /// The kind of [category].
  static CategoryKind of(Category category) => category.isSystem
      ? system
      : category.isDefault
      ? standard
      : custom;
}

/// The server's rules for changing a category, checked before asking it.
extension CategoryRules on Category {
  CategoryKind get kind => CategoryKind.of(this);

  /// A default category, or a hidden custom one to show it again.
  bool get canToggleHidden => switch (kind) {
    .standard => true,
    .custom => isHidden,
    .system => false,
  };

  bool get canDelete => kind == .custom;

  bool get canEdit => kind != .system;
}

/// [categories] by name, ignoring case, with "Other" last.
List<Category> sortCategories(Iterable<Category> categories) =>
    [...categories]..sort((a, b) {
      if (a.isSystem != b.isSystem) return a.isSystem ? 1 : -1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

/// Where [deleted]'s transactions can move: the other categories of its
/// type that aren't hidden, "Other" first.
List<Category> moveTargets(Category deleted, Iterable<Category> categories) {
  final targets = sortCategories(
    categories.where(
      (c) => c.id != deleted.id && c.type == deleted.type && !c.isHidden,
    ),
  );
  return [
    ...targets.where((c) => c.isSystem),
    ...targets.where((c) => !c.isSystem),
  ];
}
