import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_category_request.freezed.dart';
part 'update_category_request.g.dart';

/// Only the fields that are set are sent.
@freezed
abstract class UpdateCategoryRequest with _$UpdateCategoryRequest {
  const factory UpdateCategoryRequest({
    @JsonKey(name: 'name', includeIfNull: false) String? name,
    @JsonKey(name: 'icon', includeIfNull: false) String? icon,
    @JsonKey(name: 'color', includeIfNull: false) String? color,
    @JsonKey(name: 'is_hidden', includeIfNull: false) bool? isHidden,
  }) = _UpdateCategoryRequest;

  factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCategoryRequestFromJson(json);
}
