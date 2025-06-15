class ApiConstants {
  // static const String baseUrl = 'http://10.0.2.2:5041/api';
  static const String baseUrl = 'http://192.168.1.106:5041/api';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const String baseImageUrl = 'http://192.168.1.106:5041/';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Endpoints
  static const String categoriesEndpoint = '/Categories';
  static const String productsEndpoint = '/products';

  // Category endpoints
  static String getCategoriesEndpoint({
    int pageNumber = 1,
    int pageSize = 10,
  }) => '$categoriesEndpoint?pageNumber=$pageNumber&pageSize=$pageSize';

  static String getCategoryEndpoint(int id) => '$categoriesEndpoint/$id';
  static String deleteCategoryEndpoint(int id) => '$categoriesEndpoint/$id';
  static String updateCategoryEndpoint(int id) => '$categoriesEndpoint/$id';

  // Product endpoints
  static String getProductsByCategory(String categoryId) =>
      '$categoriesEndpoint/$categoryId/products';

  static String getProductEndpoint(int id) => '$productsEndpoint/$id';
  static String deleteProductEndpoint(int id) => '$productsEndpoint/$id';
  static String updateProductEndpoint(int id) => '$productsEndpoint/$id';

  // Pagination
  static const int defaultPageSize = 10;
  static const int defaultPageNumber = 1;
}
