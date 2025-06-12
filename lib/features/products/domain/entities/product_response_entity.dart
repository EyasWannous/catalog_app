import 'package:catalog_app/features/categroy/domain/entities/pagination.dart';
import 'package:equatable/equatable.dart';
import 'package:catalog_app/features/products/domain/entities/product_entity.dart';

class ProductResponseEntity extends Equatable {
  final List<ProductEntity> products;
  final Pagination pagination;
  final bool isSuccessful;
  final String responseTime;
  final String error;

  ProductResponseEntity({required this.products, required this.pagination, required this.isSuccessful, required this.responseTime, required this.error});

  @override
  List<Object?> get props => [products, pagination, isSuccessful, responseTime, error];
}
