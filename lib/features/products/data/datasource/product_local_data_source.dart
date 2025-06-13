import 'package:hive/hive.dart';

import '../model/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProductsByCategory(
    String categoryId,
    List<ProductModel> products,
  );

  Future<List<ProductModel>> getCachedProductsByCategory(String categoryId);
  Future<int> invalidateCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box box;

  ProductLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheProductsByCategory(
    String categoryId,
    List<ProductModel> products,
  ) async {
    final productMaps = products.map((product) => product.toJson()).toList();
    await box.put(categoryId, productMaps);
  }

  @override
  Future<List<ProductModel>> getCachedProductsByCategory(
    String categoryId,
  ) async {
    final productMaps = box.get(categoryId);
    if (productMaps != null) {
      return (productMaps as List)
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      return [];
    }
  }
  
  @override
  Future<int> invalidateCache() {
    return box.clear();
  }
}
