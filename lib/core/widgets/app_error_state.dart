import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message = AppStrings.somethingWentWrong,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64.r, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              AppButton.outlined(
                label: AppStrings.retry,
                onPressed: onRetry,
                width: 160.w,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
