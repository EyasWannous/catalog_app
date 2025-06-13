import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
 
  int? id;
  String? name;
  String? description;
  String? price;
  int? rating;
  int? categoryId;

  ProductEntity({this.id, this.name, this.description, this.price, this.rating, this.categoryId});

  @override
  List<Object?> get props => [id, name, description, price, rating, categoryId];

  @override
  String toString() {
    return 'ProductEntity(id: $id, name: $name, description: $description, price: $price, rating: $rating, categoryId: $categoryId)';
  } 
}
