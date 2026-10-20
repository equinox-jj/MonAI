import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/category_endpoint.dart';
import 'package:monai/features/shared/data/model/category_list_response.dart';
import 'package:monai/features/shared/data/model/category_response.dart';
import 'package:monai/features/shared/data/model/create_category_request.dart';
import 'package:monai/features/shared/data/model/update_category_request.dart';

abstract class CategoryRemoteDataSource {
  /// `GET /categories?include_hidden=true`.
  Future<CategoryListResponse> getCategories();

  /// `POST /categories`.
  Future<CategoryResponse> createCategory(CreateCategoryRequest request);

  /// `PATCH /categories/{id}`.
  Future<CategoryResponse> updateCategory(
    String id,
    UpdateCategoryRequest request,
  );

  /// `DELETE /categories/{id}`, moving its transactions to [moveTo] when
  /// given.
  Future<void> deleteCategory(String id, {String? moveTo});
}

class CategoryRemoteDataSourceImpl extends CategoryRemoteDataSource
    with BaseRemoteDataSource {
  CategoryRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  // Hidden ones too: old transactions still need their names.
  @override
  Future<CategoryListResponse> getCategories() => safeApiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      CategoryEndpoint.categories,
      queryParameters: {'include_hidden': true},
    );
    return CategoryListResponse.fromJson(response.data ?? const {});
  });

  @override
  Future<CategoryResponse> createCategory(CreateCategoryRequest request) =>
      safeApiCall(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          CategoryEndpoint.categories,
          data: request.toJson(),
        );
        return CategoryResponse.fromJson(response.data ?? const {});
      });

  @override
  Future<CategoryResponse> updateCategory(
    String id,
    UpdateCategoryRequest request,
  ) => safeApiCall(() async {
    final response = await _dio.patch<Map<String, dynamic>>(
      CategoryEndpoint.category(id),
      data: request.toJson(),
    );
    return CategoryResponse.fromJson(response.data ?? const {});
  });

  @override
  Future<void> deleteCategory(String id, {String? moveTo}) =>
      safeApiCall(() async {
        await _dio.delete<Map<String, dynamic>>(
          CategoryEndpoint.category(id),
          queryParameters: {'move_to': ?moveTo},
        );
      });
}
