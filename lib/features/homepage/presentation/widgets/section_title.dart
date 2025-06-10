import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;

  const SectionTitle({Key? key, required this.title, this.onSeeAllPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18 * ResponsiveUtils.getFontSizeMultiplier(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: onSeeAllPressed,
          child: Text(
            'see all',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14 * ResponsiveUtils.getFontSizeMultiplier(context),
            ),
          ),
        ),
      ],
    );
  }
}
