import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final int? parentId;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    this.parentId,
  });

  @override
  List<Object?> get props => [id, name, description, imagePath, parentId];

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, imagePath: $imagePath, parentId: $parentId)';
  }
}
