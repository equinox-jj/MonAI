import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category_request.freezed.dart';
part 'create_category_request.g.dart';

/// `POST /categories`.
@freezed
abstract class CreateCategoryRequest with _$CreateCategoryRequest {
  const factory CreateCategoryRequest({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'icon', includeIfNull: false) String? icon,
    @JsonKey(name: 'color', includeIfNull: false) String? color,
  }) = _CreateCategoryRequest;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestFromJson(json);
}
