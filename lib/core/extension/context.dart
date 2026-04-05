import 'package:flutter/material.dart';
import 'package:habit_tracker_app/l10n/app_localizations.dart';

extension Context on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  TextTheme get textTheme => Theme.of(this).textTheme;

  //snackbar
  void showSnackBar(String message, {Color? color = Colors.black}) {
    ScaffoldMessenger.of(
      this,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
