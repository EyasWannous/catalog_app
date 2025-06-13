import 'package:catalog_app/features/categroy/domain/repositories/category_repository.dart';
import 'package:catalog_app/features/categroy/data/models/categories_response_model.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<CategoriesResponseModel> call({int? pageNumber, int? pageSize}) async {
    return await repository.getCategories(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
