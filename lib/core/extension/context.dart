import 'package:flutter/material.dart';
import 'package:habit_tracker_app/l10n/app_localizations.dart';

extension Context on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get cardColor => Theme.of(this).cardColor;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  Color get primaryColor => Theme.of(this).primaryColor;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  //snackbar
  void showSnackBar(String message, {Color? color}) {
    final effectiveColor = color ?? (isDarkMode ? Colors.grey[800] : Colors.black);
    ScaffoldMessenger.of(
      this,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: effectiveColor));
  }
}
