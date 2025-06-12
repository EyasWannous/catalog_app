import 'package:catalog_app/features/categroy/data/models/categories_response_model.dart';

abstract class CategoryRepository {
  Future<CategoriesResponseModel> getCategories({int? pageNumber,int? pageSize});
}
