import 'package:catalog_app/core/network/api_service.dart';
import 'package:catalog_app/features/categroy/data/datasources/category_data_source.dart';
import 'package:catalog_app/features/categroy/data/models/categories_response_model.dart';

class CategoryRemoteDataSourceImpl implements CategoryDataSource {
  final ApiService apiService;

  CategoryRemoteDataSourceImpl(this.apiService);
  @override
  Future<CategoriesResponseModel> getCategories({
    int? pageNumber,
    int? pageSize,
  }) async {
    final response = await apiService.get(
      '/Categories',
      queryParameters: {
        'pageNumber': pageNumber ?? 1,
        'pageSize': pageSize ?? 10,
      },
    );
    return CategoriesResponseModel.fromJson(response.data);
  }
}