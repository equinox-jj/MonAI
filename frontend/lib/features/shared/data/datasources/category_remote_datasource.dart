import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/category_endpoint.dart';
import 'package:monai/features/shared/data/model/category_list_response.dart';

abstract class CategoryRemoteDataSource {
  /// `GET /categories?include_hidden=true`.
  Future<CategoryListResponse> getCategories();
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
}
