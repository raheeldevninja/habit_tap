import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _notificationsKey = 'notifications_enabled';
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  bool areNotificationsEnabled() {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }
}
