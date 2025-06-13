import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final int categoryId;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
  }); 

  @override
  List<Object?> get props => [id, name, description, categoryId];

  @override
  String toString() {
    return 'ProductEntity(id: $id, name: $name, description: $description, categoryId: $categoryId)';
  }
}
