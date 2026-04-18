import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import 'app_loader.dart';

enum AppButtonVariant { primary, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.variant = AppButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final AppButtonVariant variant;
  final Widget? icon;

  bool get _interactive => isEnabled && !isLoading;

  Widget _buildChild(Color loaderColor) {
    if (isLoading) return AppLoader(size: 20.r, color: loaderColor);
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon!, SizedBox(width: 8.w), Text(label)],
      );
    }
    return Text(label);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? double.infinity;

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: effectiveWidth,
          child: ElevatedButton(
            onPressed: _interactive ? onPressed : null,
            child: _buildChild(Colors.white),
          ),
        );

      case AppButtonVariant.outlined:
        return SizedBox(
          width: effectiveWidth,
          child: OutlinedButton(
            onPressed: _interactive ? onPressed : null,
            child: _buildChild(AppColors.primary),
          ),
        );

      case AppButtonVariant.text:
        return SizedBox(
          width: effectiveWidth,
          child: TextButton(
            onPressed: _interactive ? onPressed : null,
            child: _buildChild(AppColors.primary),
          ),
        );
    }
  }
}
