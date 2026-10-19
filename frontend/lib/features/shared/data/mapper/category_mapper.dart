import 'package:monai/core/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/category_list_response.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

extension CategoryDataMapper on CategoryData {
  CategoryRow toRow() => CategoryRow(
    id: requireField(id),
    name: requireField(name),
    type: parseCategoryType(type),
    icon: icon,
    color: color,
    isDefault: isDefault ?? false,
    isSystem: isSystem ?? false,
    isHidden: isHidden ?? false,
    createdAt: requireField(createdAt),
    updatedAt: requireField(updatedAt),
  );
}

extension CategoryRowMapper on CategoryRow {
  Category toEntity() => Category(
    id: id,
    name: name,
    type: type,
    icon: icon,
    color: color,
    isDefault: isDefault,
    isSystem: isSystem,
    isHidden: isHidden,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
