import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  void loadCategories() {
    emit(CategoriesLoading());

    try {
      // Simulate loading data (in real app, this would be from repository/API)
      final categories = [
        {
          'title': 'New products',
          'subtitle': 'منتجات جديدة',
          'color': const Color(0xFF9ED9D5),
          'imageUrl':
              'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&h=300&fit=crop',
          'hasProducts': true,
        },
        {
          'title': 'Body lotions',
          'subtitle': 'مرطبات الجسم',
          'color': const Color(0xFFFEC78F),
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
          'hasProducts': true,
        },
        {
          'title': 'Skin care',
          'subtitle': 'العناية بالبشرة',
          'color': const Color(0xFFFFE38F),
          'imageUrl':
              'https://images.unsplash.com/photo-1570194065650-d99fb4bedf0a?w=400&h=300&fit=crop',
          'hasProducts': false,
        },
        {
          'title': 'Shampoo',
          'subtitle': 'شامبو',
          'color': const Color(0xFFFDB9A7),
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
          'hasProducts': true,
        },
        {
          'title': 'Perfumes',
          'subtitle': 'العطورات',
          'color': const Color(0xFFE7DDCB),
          'imageUrl':
              'https://images.unsplash.com/photo-1541643600914-78b084683601?w=400&h=300&fit=crop',
          'hasProducts': false,
        },
        {
          'title': 'Make-up',
          'subtitle': 'معدات المكياج',
          'color': const Color(0xFFAED6C1),
          'imageUrl':
              'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&h=300&fit=crop',
          'hasProducts': true,
        },
      ];

      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(CategoriesError('Failed to load categories: ${e.toString()}'));
    }
  }

  void refreshCategories() {
    loadCategories();
  }

  void onCategoryTap(Map<String, dynamic> category) {
    // Handle category tap - navigate to products or show message
    print('Category tapped: ${category['title']}');
  }
}
