import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = null;

  const AppText.displayLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = _AppTextStyle.displayLarge;

  const AppText.headlineMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = _AppTextStyle.headlineMedium;

  const AppText.titleLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = _AppTextStyle.titleLarge;

  const AppText.titleMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = _AppTextStyle.titleMedium;

  const AppText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = _AppTextStyle.bodyLarge;

  const AppText.bodyMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = _AppTextStyle.bodyMedium;

  const AppText.labelLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = _AppTextStyle.labelLarge;

  const AppText.labelSmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _style = _AppTextStyle.labelSmall;

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final _AppTextStyle? _style;

  TextStyle _resolveStyle() {
    final base = switch (_style) {
      _AppTextStyle.displayLarge => AppTextStyles.displayLarge,
      _AppTextStyle.headlineMedium => AppTextStyles.headlineMedium,
      _AppTextStyle.titleLarge => AppTextStyles.titleLarge,
      _AppTextStyle.titleMedium => AppTextStyles.titleMedium,
      _AppTextStyle.bodyLarge => AppTextStyles.bodyLarge,
      _AppTextStyle.bodyMedium => AppTextStyles.bodyMedium,
      _AppTextStyle.labelLarge => AppTextStyles.labelLarge,
      _AppTextStyle.labelSmall => AppTextStyles.labelSmall,
      null => AppTextStyles.bodyMedium,
    };
    return color != null ? base.copyWith(color: color) : base;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _resolveStyle(),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}

enum _AppTextStyle {
  displayLarge,
  headlineMedium,
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  labelLarge,
  labelSmall,
}
