import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io';
import '../../features/habits/domain/habit.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final String timeZoneName =
          (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Fallback to UTC if timezone cannot be determined
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
          macOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );
  }

  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tap in foreground/background
  }

  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse response) {
    // Handle notification tap when app is in background/killed
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final bool? result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final bool? grantedNotification = await androidImplementation
          ?.requestNotificationsPermission();

      // Request exact alarm permission for Android 12+
      final bool? grantedExactAlarm = await androidImplementation
          ?.requestExactAlarmsPermission();

      return (grantedNotification ?? false) && (grantedExactAlarm ?? true);
    }
    return false;
  }

  Future<void> scheduleHabitReminder(Habit habit) async {
    if (!habit.isReminderEnabled || habit.notificationTime == null) {
      await cancelHabitReminder(habit.id);
      return;
    }

    final int baseId = habit.id.hashCode;
    final String title = 'Habit Reminder: ${habit.name}';
    const String body = 'Time to complete your habit!';

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Cancel any existing notifications for this habit first
    await cancelHabitReminder(habit.id);

    for (final int day in habit.frequency) {
      // day is 1-7 (Mon-Sun), DateTimeComponents.dayOfWeekAndTime expects weekDay
      // but the enum is slightly different in some versions or indices.
      // In flutter_local_notifications, DateTimeComponents.dayOfWeekAndTime
      // matches the weekday of the provided TZDateTime.

      // We need to find the "next" occurrence of this weekday
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        habit.notificationTime!.hour,
        habit.notificationTime!.minute,
      );

      // Adjust to the correct weekday
      int daysUntilWeekday = (day - scheduledDate.weekday) % 7;
      if (daysUntilWeekday < 0) daysUntilWeekday += 7;

      scheduledDate = scheduledDate.add(Duration(days: daysUntilWeekday));

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }

      await _notificationsPlugin.zonedSchedule(
        baseId + day,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_reminders',
            'Habit Reminders',
            channelDescription: 'Reminders for your habits',
            importance: Importance.max,
            priority: Priority.max,
            category: AndroidNotificationCategory.reminder,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: habit.id,
      );
    }
  }

  Future<void> cancelHabitReminder(String habitId) async {
    final int baseId = habitId.hashCode;
    // Cancel all possible days (1-7)
    for (int day = 1; day <= 7; day++) {
      await _notificationsPlugin.cancel(baseId + day);
    }
  }

  Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }
}
