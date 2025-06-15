import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String description;
  final String imagePath;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, name, description, imagePath];

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, attachment: $imagePath)';
  }
}
