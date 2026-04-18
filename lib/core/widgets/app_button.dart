import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import 'app_loader.dart';

enum _AppButtonVariant { primary, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.icon,
  }) : _variant = _AppButtonVariant.primary;

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.icon,
  }) : _variant = _AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.icon,
  }) : _variant = _AppButtonVariant.text;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final Widget? icon;
  final _AppButtonVariant _variant;

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

    switch (_variant) {
      case _AppButtonVariant.primary:
        return SizedBox(
          width: effectiveWidth,
          child: ElevatedButton(
            onPressed: _interactive ? onPressed : null,
            child: _buildChild(Colors.white),
          ),
        );

      case _AppButtonVariant.outlined:
        return SizedBox(
          width: effectiveWidth,
          child: OutlinedButton(
            onPressed: _interactive ? onPressed : null,
            child: _buildChild(AppColors.primary),
          ),
        );

      case _AppButtonVariant.text:
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
