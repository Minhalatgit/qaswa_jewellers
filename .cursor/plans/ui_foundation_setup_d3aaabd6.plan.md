---
name: UI Foundation Setup
overview: "Set up the full UI foundation for the app: theme, color/string constants, responsiveness via flutter_screenutil, 5 core reusable widgets, plus AppSnackbar helper, AppDivider, and empty/error state widgets."
todos:
  - id: add-packages
    content: Add flutter_screenutil and dropdown_search to pubspec.yaml, run pub get
    status: pending
  - id: app-colors
    content: Create core/theme/app_colors.dart with brand palette
    status: pending
  - id: app-text-styles
    content: Create core/theme/app_text_styles.dart using sp extensions
    status: pending
  - id: app-theme
    content: Create core/theme/app_theme.dart with light() factory (ColorScheme, TextTheme, InputDecorationTheme, ButtonTheme, AppBarTheme)
    status: pending
  - id: app-strings
    content: Create core/constants/app_strings.dart with all current string literals
    status: pending
  - id: app-spacing
    content: Create core/constants/app_spacing.dart with xs/sm/md/lg/xl/xxl constants
    status: pending
  - id: widget-text-field
    content: Create core/widgets/app_text_field.dart
    status: pending
  - id: widget-search-field
    content: Create core/widgets/app_search_field.dart
    status: pending
  - id: widget-dropdown
    content: Create core/widgets/app_dropdown_field.dart wrapping dropdown_search (single + multi)
    status: pending
  - id: widget-button
    content: Create core/widgets/app_button.dart (primary/outlined/text variants, loading + disabled states)
    status: pending
  - id: widget-loader
    content: Create core/widgets/app_loader.dart with CircularProgressIndicator.adaptive
    status: pending
  - id: barrel-file
    content: Create core/widgets/widgets.dart barrel export
    status: pending
  - id: update-main
    content: "Update main.dart: ScreenUtilInit wrapper + AppTheme.light()"
    status: pending
  - id: update-login-form
    content: Refactor login_form.dart to use AppTextField, AppButton, AppLoader instead of raw Flutter widgets
    status: pending
  - id: widget-snackbar
    content: Create core/widgets/app_snackbar.dart with showSuccess/showError/showInfo helpers
    status: pending
  - id: widget-divider
    content: Create core/widgets/app_divider.dart using AppColors.border
    status: pending
  - id: widget-empty-state
    content: Create core/widgets/app_empty_state.dart and app_error_state.dart
    status: pending
isProject: false
---

# UI Foundation Setup

## New packages to add (pubspec.yaml)

- `flutter_screenutil` — responsiveness (sp, w, h, r extensions)
- `dropdown_search` — dropdown with search + single/multi selection

---

## File structure after this work

```
lib/core/
├── constants/
│   ├── api_constants.dart        (existing)
│   ├── storage_keys.dart         (existing)
│   ├── app_strings.dart          ← NEW: all string literals
│   └── app_spacing.dart          ← NEW: spacing/sizing constants (see note)
├── theme/
│   ├── app_colors.dart           ← NEW
│   ├── app_text_styles.dart      ← NEW
│   └── app_theme.dart            ← NEW
└── widgets/
    ├── app_text_field.dart       ← NEW
    ├── app_search_field.dart     ← NEW
    ├── app_dropdown_field.dart   ← NEW
    ├── app_button.dart           ← NEW
    ├── app_loader.dart           ← NEW
    ├── app_snackbar.dart         ← NEW
    ├── app_divider.dart          ← NEW
    ├── app_empty_state.dart      ← NEW
    ├── app_error_state.dart      ← NEW
    └── widgets.dart              ← NEW: barrel export
```

---

## 1 — Color constants: `core/theme/app_colors.dart`

Brand palette based on the existing seed color `0xFFB8860B` (dark goldenrod):

```dart
class AppColors {
  static const Color primary     = Color(0xFFB8860B); // dark goldenrod
  static const Color primaryDark = Color(0xFF8B6508);
  static const Color accent      = Color(0xFFFFD700); // gold
  static const Color background  = Color(0xFFF5F5F0);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color error       = Color(0xFFD32F2F);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color border      = Color(0xFFE0E0E0);
  static const Color disabled    = Color(0xFFBDBDBD);
}
```

---

## 2 — Text styles: `core/theme/app_text_styles.dart`

Uses `flutter_screenutil` `sp` extension. Provides named styles:
`displayLarge`, `headlineMedium`, `titleLarge`, `bodyLarge`, `bodyMedium`, `labelLarge`, `labelSmall` — all referencing `AppColors` for color.

---

## 3 — Theme: `core/theme/app_theme.dart`

A factory class with a static `light()` method returning a fully configured `ThemeData` (Material 3) — `ColorScheme`, `TextTheme`, `InputDecorationTheme`, `ElevatedButtonTheme`, `AppBarTheme` — all sourced from `AppColors` and `AppTextStyles`.

---

## 4 — String constants: `core/constants/app_strings.dart`

```dart
class AppStrings {
  // Auth
  static const String login       = 'Login';
  static const String logout      = 'Logout';
  static const String email       = 'Email';
  static const String password    = 'Password';
  static const String search      = 'Search';
  static const String loading     = 'Loading...';
  static const String selectOption = 'Select an option';
  // Validation
  static const String fieldRequired    = 'This field is required';
  static const String invalidEmail     = 'Enter a valid email address';
  static const String passwordMinLength = 'Password must be at least 6 characters';
  // ... more added as features grow
}
```

---

## 5 — Spacing constants: `core/constants/app_spacing.dart` *(extra, recommended)*

```dart
class AppSpacing {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;
}
```

These feed `SizedBox` and `EdgeInsets` throughout the app, keeping spacing consistent without magic numbers.

---

## 6 — Responsiveness: `flutter_screenutil`

- **Design dimensions:** `375 × 812` (iPhone 13 mini — common baseline)
- **`main.dart`** wraps `MaterialApp` in `ScreenUtilInit`:

```dart
ScreenUtilInit(
  designSize: const Size(375, 812),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (_, child) => MaterialApp.router(...),
)
```

All widgets use `.w`, `.h`, `.r`, `.sp` extensions instead of hardcoded values.

---

## 7 — Reusable widgets

### `AppTextField`
Parameters: `label`, `hint`, `controller`, `validator`, `obscureText`, `keyboardType`, `onChanged`, `prefix/suffixIcon`, `enabled`, `readOnly`. Styled via `AppTheme`'s `InputDecorationTheme` — no inline decoration.

### `AppSearchField`
Thin wrapper around `AppTextField` with a search prefix icon, `TextInputAction.search`, and an `onSearch` callback. Debounce optional.

### `AppDropdownField<T>`
Wraps `dropdown_search` `DropdownSearch<T>`. Exposes:
- `items` (list) or `asyncItems` (future-based for server search)
- `selectedItem` / `selectedItems` (single vs multi)
- `onChanged` / `onChangedMultiSelection`
- `label`, `hint`, `validator`
- `isMultiSelection` flag toggles between `DropdownSearch` and `DropdownSearch.multiSelection`

### `AppButton`
Parameters: `label`, `onPressed`, `isLoading`, `isEnabled`, `width` (defaults to full), `variant` (primary / outlined / text). When `isLoading` is true, replaces label with `AppLoader`. When `isEnabled` is false, disables tap and applies disabled color.

### `AppLoader`
```dart
class AppLoader extends StatelessWidget {
  final double size;
  final Color? color;
  // renders CircularProgressIndicator.adaptive
}
```

---

## 9 — `AppSnackbar` helper: `core/widgets/app_snackbar.dart`

A static utility class — no `BuildContext` stored, just thin wrappers over `ScaffoldMessenger`:

```dart
class AppSnackbar {
  static void showSuccess(BuildContext context, String message) { ... }
  static void showError(BuildContext context, String message) { ... }
  static void showInfo(BuildContext context, String message) { ... }
}
```

Each variant uses a distinct background color (`AppColors.primary` for success, `AppColors.error` for error, etc.) and a matching icon. This ensures no feature layer ever calls `ScaffoldMessenger` directly.

---

## 10 — `AppDivider`: `core/widgets/app_divider.dart`

```dart
class AppDivider extends StatelessWidget {
  final double? indent;
  final double thickness;
  // renders Divider with color: AppColors.border
}
```

---

## 11 — Empty/error state widgets

### `AppEmptyState` (`core/widgets/app_empty_state.dart`)
Parameters: `message`, `icon` (optional), `action` (optional `AppButton`). Used on list/grid screens when the result set is empty.

### `AppErrorState` (`core/widgets/app_error_state.dart`)
Parameters: `message`, `onRetry` callback. Shows the error message and a "Retry" `AppButton`. Used in BLoC error states across all features.

---

## 12 — `main.dart` changes

- Replace inline `ThemeData(...)` with `AppTheme.light()`
- Wrap `MaterialApp.router` with `ScreenUtilInit`
- Update `LoginForm` widget to use `AppTextField` and `AppButton` in place of raw `TextFormField` / `FilledButton`
