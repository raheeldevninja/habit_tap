import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/settings_service.dart';
import '../domain/habit.dart';

class HabitRepository {
  static const String boxName = 'habitsBox';
  final Box<Habit> _box;
  final NotificationService _notificationService;
  final SettingsService _settingsService;

  HabitRepository(this._box, this._notificationService, this._settingsService);

  static Future<HabitRepository> init(
    NotificationService notificationService,
    SettingsService settingsService,
  ) async {
    Hive.registerAdapter(HabitAdapter());
    final box = await Hive.openBox<Habit>(boxName);
    return HabitRepository(box, notificationService, settingsService);
  }

  List<Habit> getHabits() {
    return _box.values.toList();
  }

  Habit? getHabit(String id) {
    return _box.get(id);
  }

  Future<void> addHabit(Habit habit) async {
    await _box.put(habit.id, habit);
    if (_settingsService.areNotificationsEnabled()) {
      await _notificationService.scheduleHabitReminder(habit);
    }
  }

  Future<void> updateHabit(Habit habit) async {
    await _box.put(habit.id, habit);
    if (_settingsService.areNotificationsEnabled()) {
      await _notificationService.scheduleHabitReminder(habit);
    } else {
      await _notificationService.cancelHabitReminder(habit.id);
    }
  }

  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
    await _notificationService.cancelHabitReminder(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
    await _notificationService.cancelAllReminders();
  }

  Future<void> importHabits(List<Habit> habits) async {
    await clearAll();
    for (final habit in habits) {
      await _box.put(habit.id, habit);
    }
    rescheduleAllReminders();
  }

  void rescheduleAllReminders() {
    final enabled = _settingsService.areNotificationsEnabled();
    if (enabled) {
      for (final habit in getHabits()) {
        _notificationService.scheduleHabitReminder(habit);
      }
    } else {
      _notificationService.cancelAllReminders();
    }
  }
}

// Global Provider for HabitRepository. Requires overriding in ProviderScope if async init is needed,
// but since this is Hive it's best to init before runApp.
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  throw UnimplementedError('habitRepositoryProvider must be overridden');
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  throw UnimplementedError('settingsServiceProvider must be overridden');
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('notificationServiceProvider must be overridden');
});
