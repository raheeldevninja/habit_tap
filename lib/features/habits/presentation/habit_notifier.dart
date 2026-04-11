import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/habit.dart';
import '../data/habit_repository.dart';

class HabitListNotifier extends AsyncNotifier<List<Habit>> {
  @override
  FutureOr<List<Habit>> build() async {
    final repository = ref.watch(habitRepositoryProvider);
    return repository.getHabits();
  }

  Future<void> addHabit(Habit habit) async {
    final repository = ref.read(habitRepositoryProvider);
    final previousState = state;
    
    // Optimistic update
    state = AsyncValue.data([...(state.valueOrNull ?? []), habit]);

    final result = await AsyncValue.guard(() async {
      await repository.addHabit(habit);
      return repository.getHabits();
    });

    if (result.hasError) {
      state = previousState;
    } else {
      state = result;
    }
  }

  Future<void> updateHabit(Habit habit) async {
    final repository = ref.read(habitRepositoryProvider);
    final previousState = state;

    // Optimistic update
    state = AsyncValue.data(
      (state.valueOrNull ?? []).map((h) => h.id == habit.id ? habit : h).toList(),
    );

    final result = await AsyncValue.guard(() async {
      await repository.updateHabit(habit);
      return repository.getHabits();
    });

    if (result.hasError) {
      state = previousState;
    } else {
      state = result;
    }
  }

  Future<void> deleteHabit(String id) async {
    final repository = ref.read(habitRepositoryProvider);
    final previousState = state;

    // Optimistic update
    state = AsyncValue.data(
      (state.valueOrNull ?? []).where((h) => h.id != id).toList(),
    );

    final result = await AsyncValue.guard(() async {
      await repository.deleteHabit(id);
      return repository.getHabits();
    });

    if (result.hasError) {
      state = previousState;
    } else {
      state = result;
    }
  }

  Future<void> deleteAll() async {
    final repository = ref.read(habitRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.clearAll();
      return repository.getHabits();
    });
  }

  Future<void> importData(List<Habit> habits) async {
    final repository = ref.read(habitRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.importHabits(habits);
      return repository.getHabits();
    });
  }

  void refresh() {
    ref.invalidateSelf();
  }

  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    final currentValue = state.valueOrNull ?? [];
    final habitIndex = currentValue.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return;

    final habit = currentValue[habitIndex];
    final previousState = state;

    // Normalize date to ignore time component
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final Set<DateTime> uniqueDates = habit.completedDates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    if (uniqueDates.contains(normalizedDate)) {
      uniqueDates.remove(normalizedDate);
    } else {
      uniqueDates.add(normalizedDate);
    }

    final List<DateTime> updatedDates = uniqueDates.toList()..sort();

    // Recalculate streaks
    final (currentStreak, bestStreak) = _recalculateStreaks(
      updatedDates,
      habit.frequency,
    );

    final updatedHabit = habit.copyWith(
      completedDates: updatedDates,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );

    // Optimistic update
    final updatedList = List<Habit>.from(currentValue);
    updatedList[habitIndex] = updatedHabit;
    state = AsyncValue.data(updatedList);

    final repository = ref.read(habitRepositoryProvider);
    final result = await AsyncValue.guard(() async {
      await repository.updateHabit(updatedHabit);
      return repository.getHabits();
    });

    if (result.hasError) {
      state = previousState;
    } else {
      // Use the refreshed data from the repository to ensure consistency
      state = result;
    }
  }

  (int, int) _recalculateStreaks(List<DateTime> dates, List<int> frequency) {
    if (dates.isEmpty) return (0, 0);
    if (frequency.isEmpty) return (0, 0);

    // Dates are already normalized and sorted unique
    final Set<DateTime> uniqueDates = dates.toSet();

    int bestStreak = 0;
    int currentSegment = 0;

    // Calculate Best Streak
    if (dates.isNotEmpty) {
      currentSegment = 1;
      bestStreak = 1;
      for (int i = 1; i < dates.length; i++) {
        if (_isNextScheduledDay(dates[i - 1], dates[i], frequency)) {
          currentSegment++;
        } else {
          currentSegment = 1;
        }
        if (currentSegment > bestStreak) bestStreak = currentSegment;
      }
    }

    // Calculate Current Streak
    int currentStreak = 0;
    DateTime today = DateTime.now();
    DateTime checkDate = DateTime(today.year, today.month, today.day);

    // If today is not completed, we need to check if the streak is still "alive"
    if (!uniqueDates.contains(checkDate)) {
      // If today is a scheduled day but not completed, streak is broken
      if (frequency.contains(checkDate.weekday)) {
        currentStreak = 0;
      } else {
        // Today is not scheduled, check backwards from today to find the last scheduled day
        DateTime lastScheduled = checkDate.subtract(const Duration(days: 1));
        while (!frequency.contains(lastScheduled.weekday)) {
          lastScheduled = lastScheduled.subtract(const Duration(days: 1));
        }

        // If that last scheduled day was completed, the streak is alive
        if (uniqueDates.contains(lastScheduled)) {
          currentStreak = _countBackwards(
            uniqueDates,
            lastScheduled,
            frequency,
          );
        } else {
          currentStreak = 0;
        }
      }
    } else {
      // Today is completed
      currentStreak = _countBackwards(uniqueDates, checkDate, frequency);
    }

    return (currentStreak, bestStreak);
  }

  bool _isNextScheduledDay(DateTime prev, DateTime curr, List<int> frequency) {
    DateTime next = prev.add(const Duration(days: 1));
    while (!frequency.contains(next.weekday)) {
      next = next.add(const Duration(days: 1));
      // Safety break
      if (next.year > curr.year + 1) return false;
    }
    return next.year == curr.year &&
        next.month == curr.month &&
        next.day == curr.day;
  }

  int _countBackwards(
    Set<DateTime> uniqueDates,
    DateTime startDate,
    List<int> frequency,
  ) {
    int streak = 0;
    DateTime checkDate = startDate;

    while (uniqueDates.contains(checkDate)) {
      streak++;
      // Move to previous scheduled day
      checkDate = checkDate.subtract(const Duration(days: 1));
      while (!frequency.contains(checkDate.weekday)) {
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    }
    return streak;
  }
}

final habitListProvider = AsyncNotifierProvider<HabitListNotifier, List<Habit>>(
  () => HabitListNotifier(),
);
