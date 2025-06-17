import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/category.dart';
import 'expandable_category_card.dart';

class ExpandableCategoriesList extends StatefulWidget {
  final List<Category> categories;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onEndReached;
  final bool isAdmin;

  const ExpandableCategoriesList({
    super.key,
    required this.categories,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onEndReached,
    required this.isAdmin,
  });

  @override
  State<ExpandableCategoriesList> createState() =>
      _ExpandableCategoriesListState();
}

class _ExpandableCategoriesListState extends State<ExpandableCategoriesList> {
  late final ScrollController _scrollController;
  final Set<int> _expandedCategories = <int>{};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
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

  void _toggleExpansion(int categoryId) {
    setState(() {
      if (_expandedCategories.contains(categoryId)) {
        _expandedCategories.remove(categoryId);
      } else {
        _expandedCategories.add(categoryId);
      }
    });
  }

  // Mock subcategories for demonstration
  List<Category> _getSubcategories(Category category) {
    // This is mock data - in a real app, you'd fetch from your API
    return [
      Category(
        id: category.id * 100 + 1,
        name: '${category.name} - Premium',
        description: 'Premium ${category.description}',
        imagePath: category.imagePath,
      ),
      Category(
        id: category.id * 100 + 2,
        name: '${category.name} - Basic',
        description: 'Basic ${category.description}',
        imagePath: category.imagePath,
      ),
      Category(
        id: category.id * 100 + 3,
        name: '${category.name} - Special',
        description: 'Special ${category.description}',
        imagePath: category.imagePath,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ResponsiveUtils.getMaxContentWidth(context),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
          top: ResponsiveUtils.getResponsiveSpacing(context, 16),
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        itemCount: widget.categories.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < widget.categories.length) {
            final category = widget.categories[index];
            final isExpanded = _expandedCategories.contains(category.id);
            final subcategories = _getSubcategories(category);

            return Column(
              children: [
                ExpandableCategoryCard(
                  category: category,
                  index: index,
                  isAdmin: widget.isAdmin,
                  isExpanded: isExpanded,
                  hasSubcategories: subcategories.isNotEmpty,
                  onToggleExpansion: () => _toggleExpansion(category.id),
                ),

                // Animated subcategories section
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: isExpanded ? null : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isExpanded ? 1.0 : 0.0,
                    child: isExpanded
                        ? Container(
                            margin: EdgeInsets.only(
                              left: ResponsiveUtils.getResponsiveSpacing(
                                context,
                                20.0,
                              ),
                              right: ResponsiveUtils.getResponsiveSpacing(
                                context,
                                4.0,
                              ),
                              bottom: ResponsiveUtils.getResponsiveSpacing(
                                context,
                                16.0,
                              ),
                            ),
                            child: Column(
                              children: subcategories.asMap().entries.map((
                                entry,
                              ) {
                                final subIndex = entry.key;
                                final subcategory = entry.value;

                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom:
                                        ResponsiveUtils.getResponsiveSpacing(
                                          context,
                                          8.0,
                                        ),
                                  ),
                                  child: ExpandableCategoryCard(
                                    category: subcategory,
                                    index: subIndex,
                                    isAdmin: widget.isAdmin,
                                    isSubcategory: true,
                                    isExpanded: false,
                                    hasSubcategories: false,
                                    onToggleExpansion: () {},
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.getResponsiveSpacing(context, 16.0),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
