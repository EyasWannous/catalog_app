import 'package:hive/hive.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';

part 'category_model.g.dart'; // Needed for code generation

@HiveType(typeId: 0)
class CategoryModel extends Category {
  @HiveField(0)
  final int hiveId;

  @HiveField(1)
  final String hiveName;

  @HiveField(2)
  final String hiveDescription;

  @HiveField(3)
  final String? hiveImagePath; // Made nullable

  @HiveField(4)
  final int? hiveParentId; // Added parentId field

  const CategoryModel({
    required this.hiveId,
    required this.hiveName,
    required this.hiveDescription,
    this.hiveImagePath, // Now optional
    this.hiveParentId, // Now optional
  }) : super(
          id: hiveId,
          name: hiveName,
          description: hiveDescription,
          imagePath: hiveImagePath ?? '',
          parentId: hiveParentId,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      hiveId: json['id'] as int? ?? 0, // Provide default value
      hiveName: json['name'] as String? ?? '', // Provide default value
      hiveDescription: json['description'] as String? ?? '', // Provide default value
      hiveImagePath: json['imagePath'] as String?, // Can be null
      hiveParentId: json['parentId'] as int?, // Can be null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': hiveId,
      'name': hiveName,
      'description': hiveDescription,
      'imagePath': hiveImagePath, // Can be null
      'parentId': hiveParentId, // Can be null
    };
  }
}