import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int iconCode;

  @HiveField(3)
  int colorValue;

  @HiveField(4)
  String category;

  @HiveField(5)
  bool isReminderEnabled;

  @HiveField(6)
  DateTime? notificationTime;

  @HiveField(7)
  List<int> frequency; // Days of the week (1 = Monday, 7 = Sunday)

  @HiveField(8)
  List<DateTime> completedDates;

  @HiveField(9)
  int currentStreak;

  @HiveField(10)
  int bestStreak;

  @HiveField(11)
  DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
    required this.category,
    required this.isReminderEnabled,
    this.notificationTime,
    this.frequency = const [1, 2, 3, 4, 5, 6, 7], // Default to every day
    this.completedDates = const [],
    this.currentStreak = 0,
    this.bestStreak = 0,
    required this.createdAt,
  });

  Habit copyWith({
    String? id,
    String? name,
    int? iconCode,
    int? colorValue,
    String? category,
    bool? isReminderEnabled,
    DateTime? notificationTime,
    List<int>? frequency,
    List<DateTime>? completedDates,
    int? currentStreak,
    int? bestStreak,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      colorValue: colorValue ?? this.colorValue,
      category: category ?? this.category,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
      frequency: frequency ?? this.frequency,
      completedDates: completedDates ?? this.completedDates,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Whether the habit is completed today
  bool get isCompletedToday {
    final today = DateTime.now();
    return completedDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }

  /// Get Color object from colorValue
  Color get color => Color(colorValue);

  /// Get IconData object from iconCode
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'colorValue': colorValue,
      'category': category,
      'isReminderEnabled': isReminderEnabled,
      'notificationTime': notificationTime?.toIso8601String(),
      'frequency': frequency,
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      name: json['name'] as String,
      iconCode: json['iconCode'] as int,
      colorValue: json['colorValue'] as int,
      category: json['category'] as String,
      isReminderEnabled: json['isReminderEnabled'] as bool,
      notificationTime: json['notificationTime'] != null
          ? DateTime.parse(json['notificationTime'] as String)
          : null,
      frequency: List<int>.from(json['frequency'] as List),
      completedDates: (json['completedDates'] as List)
          .map((d) => DateTime.parse(d as String))
          .toList(),
      currentStreak: json['currentStreak'] as int,
      bestStreak: json['bestStreak'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
