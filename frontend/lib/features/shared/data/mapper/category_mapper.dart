import 'package:monai/core/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/category_list_response.dart';
import 'package:monai/features/shared/data/model/create_category_request.dart';
import 'package:monai/features/shared/data/model/update_category_request.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_changes.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';

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

extension CategoryInputMapper on CategoryInput {
  CreateCategoryRequest toRequest() => CreateCategoryRequest(
    name: name,
    type: type.apiValue,
    icon: icon,
    color: color,
  );
}

extension CategoryChangesMapper on CategoryChanges {
  UpdateCategoryRequest toRequest() => UpdateCategoryRequest(
    name: name,
    icon: icon,
    color: color,
    isHidden: isHidden,
  );
}
