import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import 'app_text_field.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hint = AppStrings.search,
    this.onSearch,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(Icons.search_outlined),
      onChanged: onChanged,
      onFieldSubmitted: onSearch,
    );
  }
}
