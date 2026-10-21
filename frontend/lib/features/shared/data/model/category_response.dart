import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/data/model/category_list_response.dart';

part 'category_response.freezed.dart';
part 'category_response.g.dart';

@freezed
abstract class CategoryResponse with _$CategoryResponse {
  const factory CategoryResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') CategoryData? data,
  }) = _CategoryResponse;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}
