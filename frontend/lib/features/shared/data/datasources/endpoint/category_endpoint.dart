abstract final class CategoryEndpoint {
  static const categories = '/categories';

  static String category(String id) => '/categories/$id';
}
