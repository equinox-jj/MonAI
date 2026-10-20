/// Category API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class CategoryEndpoint {
  /// `GET`: every category; `POST`: create one.
  static const categories = '/categories';

  /// `PATCH`, `DELETE`: one category.
  static String category(String id) => '/categories/$id';
}
