import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.indent, this.endIndent, this.thickness = 1});

  final double? indent;
  final double? endIndent;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.border,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
