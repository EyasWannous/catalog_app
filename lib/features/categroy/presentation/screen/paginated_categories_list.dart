import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../widgets/categories_list.dart';

class PaginatedCategoriesList extends StatefulWidget {
  final List<Category> categories;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onEndReached;

  const PaginatedCategoriesList({
    super.key,
    required this.categories,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onEndReached,
  });

  @override
  State<PaginatedCategoriesList> createState() => _PaginatedCategoriesListState();
}

class _PaginatedCategoriesListState extends State<PaginatedCategoriesList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    // Handle case where list is already at the bottom
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    final position = _scrollController.position;


    if (position.pixels >= position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoadingMore) {
        widget.onEndReached();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CategoriesList(
      categories: widget.categories,
      scrollController: _scrollController,
      isLoadingMore: widget.isLoadingMore,
    );
  }
}
