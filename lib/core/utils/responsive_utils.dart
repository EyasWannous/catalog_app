import 'package:flutter/material.dart';

/// Responsive utility class to handle different screen sizes
class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if the current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if the current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if the current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 14);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 48);
    }
  }

  /// Get responsive card width for grid layouts
  static double getCardWidth(BuildContext context, {int columns = 2}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = getResponsivePadding(context);
    final availableWidth = screenWidth - padding.horizontal;

    if (isMobile(context)) {
      return (availableWidth - (16 * (columns - 1))) / columns;
    } else if (isTablet(context)) {
      final tabletColumns = columns + 1;
      return (availableWidth - (16 * (tabletColumns - 1))) / tabletColumns;
    } else {
      final desktopColumns = columns + 2;
      return (availableWidth - (16 * (desktopColumns - 1))) / desktopColumns;
    }
  }

  /// Get responsive grid columns count
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Get responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isMobile(context)) {
      return baseSpacing;
    } else if (isTablet(context)) {
      return baseSpacing * 1.2;
    } else {
      return baseSpacing * 1.5;
    }
  }

  /// Get responsive container max width for content
  static double getMaxContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isMobile(context)) {
      return screenWidth;
    } else if (isTablet(context)) {
      return 800;
    } else {
      return 1200;
    }
  }

  /// Get responsive ad card width for horizontal lists
  static double getAdCardWidth(BuildContext context) {
    if (isMobile(context)) {
      return 200;
    } else if (isTablet(context)) {
      return 240;
    } else {
      return 280;
    }
  }

  /// Get responsive ad card height for horizontal lists
  static double getAdCardHeight(BuildContext context) {
    if (isMobile(context)) {
      return 320;
    } else if (isTablet(context)) {
      return 360;
    } else {
      return 400;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    final multiplier = getFontSizeMultiplier(context);
    return baseSize * multiplier;
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(
    BuildContext context,
    double baseRadius,
  ) {
    if (isMobile(context)) {
      return baseRadius;
    } else if (isTablet(context)) {
      return baseRadius * 1.2;
    } else {
      return baseRadius * 1.5;
    }
  }
}
