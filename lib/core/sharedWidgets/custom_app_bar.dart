import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String searchHint;
  final VoidCallback? onMenuPressed;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;
  final bool showSearch;
  final bool showDrawer;
  final Color backgroundColor;
  final Color textColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.searchHint = 'ابحث عن المنتج الذي تريده',
    this.onMenuPressed,
    this.onSearchChanged,
    this.searchController,
    this.showSearch = true,
    this.showDrawer = true,
    this.backgroundColor = const Color(0xFFFFC1D4),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                ResponsiveUtils.isTablet(context) ||
                    ResponsiveUtils.isDesktop(context)
                ? 24
                : 16,
            vertical: 8,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: ResponsiveUtils.getResponsiveIconSize(context, 16),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      title ?? "Logo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize:
                            16 * ResponsiveUtils.getFontSizeMultiplier(context),
                      ),
                      maxLines: 1, // Ensures text stays on one line
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  if (showDrawer)
                    GestureDetector(
                      onTap: onMenuPressed,
                      child: Icon(
                        Icons.menu,
                        color: textColor,
                        size: ResponsiveUtils.getResponsiveIconSize(
                          context,
                          24,
                        ),
                      ),
                    ),
                ],
              ),

              // Search bar (if enabled)
              if (showSearch) ...[
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: onSearchChanged,
                          decoration: InputDecoration(
                            hintText: searchHint,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize:
                                  14 *
                                  ResponsiveUtils.getFontSizeMultiplier(
                                    context,
                                  ),
                              color: Colors.grey[600],
                            ),
                          ),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize:
                                14 *
                                ResponsiveUtils.getFontSizeMultiplier(context),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: ResponsiveUtils.getResponsiveIconSize(
                          context,
                          24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    // Use a larger height for tablets to prevent overflow
    if (showSearch) {
      return Size.fromHeight(160); // Increased for large tablets
    } else {
      return Size.fromHeight(80);
    }
  }
}

// Extension to make it easier to get responsive app bar height
extension CustomAppBarExtension on CustomAppBar {
  static double getAppBarHeight(
    BuildContext context, {
    bool showSearch = true,
  }) {
    return ResponsiveUtils.isTablet(context) ||
            ResponsiveUtils.isDesktop(context)
        ? (showSearch ? 140 : 80)
        : (showSearch ? 120 : 60);
  }
}
