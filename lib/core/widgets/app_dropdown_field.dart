import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    this.items = const [],
    this.asyncItems,
    this.selectedItem,
    this.onChanged,
    this.label,
    this.hint = AppStrings.selectOption,
    this.validator,
    this.enabled = true,
    this.isMultiSelection = false,
    this.selectedItems = const [],
    this.onChangedMultiSelection,
    this.itemAsString,
    this.compareFn,
  }) : assert(
          !isMultiSelection ||
              (onChangedMultiSelection != null || onChanged == null),
          'Use onChangedMultiSelection when isMultiSelection is true',
        );

  final List<T> items;
  final Future<List<T>> Function(String)? asyncItems;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String hint;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final bool isMultiSelection;
  final List<T> selectedItems;
  final ValueChanged<List<T>>? onChangedMultiSelection;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;

  @override
  Widget build(BuildContext context) {
    if (isMultiSelection) {
      return DropdownSearch<T>.multiSelection(
        items: (filter, _) async {
          if (asyncItems != null) return asyncItems!(filter);
          if (filter.isEmpty) return items;
          final lower = filter.toLowerCase();
          return items.where((i) {
            final label = itemAsString?.call(i) ?? i.toString();
            return label.toLowerCase().contains(lower);
          }).toList();
        },
        selectedItems: selectedItems,
        onChanged: onChangedMultiSelection,
        enabled: enabled,
        itemAsString: itemAsString ?? (item) => item.toString(),
        compareFn: compareFn,
        validator: (val) =>
            validator != null ? validator!(val?.firstOrNull) : null,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
          ),
        ),
        popupProps: const PopupPropsMultiSelection.menu(
          showSearchBox: true,
          showSelectedItems: true,
        ),
      );
    }

    return DropdownSearch<T>(
      items: (filter, _) async {
        if (asyncItems != null) return asyncItems!(filter);
        if (filter.isEmpty) return items;
        final lower = filter.toLowerCase();
        return items.where((i) {
          final label = itemAsString?.call(i) ?? i.toString();
          return label.toLowerCase().contains(lower);
        }).toList();
      },
      selectedItem: selectedItem,
      onChanged: enabled ? onChanged : null,
      itemAsString: itemAsString ?? (item) => item.toString(),
      compareFn: compareFn,
      validator: validator,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
    );
  }
}
