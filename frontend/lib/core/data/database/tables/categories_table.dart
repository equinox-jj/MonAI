import 'package:drift/drift.dart';
import 'package:monai/core/model/category_type.dart';

/// The user's categories, system ones included.
@DataClassName('CategoryRow')
@TableIndex(name: 'index_categories_type', columns: {#type})
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<CategoryType>()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  BoolColumn get isDefault => boolean()();
  BoolColumn get isSystem => boolean()();
  BoolColumn get isHidden => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
