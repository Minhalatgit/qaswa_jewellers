import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size, this.color});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? 24.r;
    return SizedBox(
      width: dimension,
      height: dimension,
      child: CircularProgressIndicator.adaptive(
        valueColor:
            color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
        strokeWidth: 2.5,
      ),
    );
  }
}
