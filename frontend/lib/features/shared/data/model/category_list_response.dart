import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_list_response.freezed.dart';
part 'category_list_response.g.dart';

/// `GET /categories`.
@freezed
abstract class CategoryListResponse with _$CategoryListResponse {
  const factory CategoryListResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') List<CategoryData>? data,
  }) = _CategoryListResponse;

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryListResponseFromJson(json);
}

@freezed
abstract class CategoryData with _$CategoryData {
  const factory CategoryData({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'color') String? color,
    @JsonKey(name: 'is_default') bool? isDefault,
    @JsonKey(name: 'is_system') bool? isSystem,
    @JsonKey(name: 'is_hidden') bool? isHidden,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryData;

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);
}
