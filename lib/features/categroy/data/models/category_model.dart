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

  const CategoryModel({
    required this.hiveId,
    required this.hiveName,
    required this.hiveDescription,
  }) : super(id: hiveId, name: hiveName, description: hiveDescription);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      hiveId: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      hiveName: json['name']?.toString() ?? '',
      hiveDescription: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': hiveId, 'name': hiveName, 'description': hiveDescription};
  }
}
