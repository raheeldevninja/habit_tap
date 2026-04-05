import 'package:flutter/material.dart';
import 'package:habit_tracker_app/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker_app/features/habits/presentation/habit_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker_app/core/extension/context.dart';
import '../domain/habit.dart';

class HabitsMainScreen extends ConsumerStatefulWidget {
  const HabitsMainScreen({super.key});

  @override
  ConsumerState<HabitsMainScreen> createState() => _HabitsMainScreenState();
}

class _HabitsMainScreenState extends ConsumerState<HabitsMainScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitListProvider);

    return Scaffold(
      body: SafeArea(
        child: habitsAsync.when(
          data: (habits) {
            // Filter habits for the selected day based on their frequency
            final activeHabitsForDay = habits
                .where(
                  (h) =>
                      h.frequency.contains(selectedDate.weekday) &&
                      !h.completedDates.any((d) => _isSameDay(d, selectedDate)),
                )
                .toList();

            final completedHabitsForDay = habits
                .where(
                  (h) =>
                      h.frequency.contains(selectedDate.weekday) &&
                      h.completedDates.any((d) => _isSameDay(d, selectedDate)),
                )
                .toList();

            int totalForDay =
                activeHabitsForDay.length + completedHabitsForDay.length;
            double progress = totalForDay == 0
                ? 0.0
                : completedHabitsForDay.length / totalForDay;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildCalendarStrip(),
                const SizedBox(height: 24),
                _buildProgressCard(
                  context,
                  progress,
                  completedHabitsForDay.length,
                  totalForDay,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      if (activeHabitsForDay.isNotEmpty) ...[
                        _buildSectionHeader(
                          context.l10n.todayHabits,
                          "${activeHabitsForDay.length} ${context.l10n.left}",
                        ),
                        const SizedBox(height: 12),
                        ...activeHabitsForDay.map(
                          (h) => _buildHabitCard(h, false),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (completedHabitsForDay.isNotEmpty) ...[
                        Text(
                          context.l10n.completed,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textLightColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...[
                          SizedBox(height: 10), // Add this temporary dummy
                          ...completedHabitsForDay.map(
                            (h) =>
                                _buildHabitCard(h, true, key: ValueKey(h.id)),
                          ),
                        ],
                      ],
                      const SizedBox(height: 80), // Padding for FAB
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading habits: $error',
                  style: const TextStyle(color: AppTheme.textLightColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(habitListProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(selectedDate),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.subtract(
                      const Duration(days: 7),
                    );
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.add(const Duration(days: 7));
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip() {
    // Generate dates for current week
    final int currentWeekday = selectedDate.weekday;
    final DateTime startOfWeek = selectedDate.subtract(
      Duration(days: currentWeekday - 1),
    );
    final List<DateTime> weekDates = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = weekDates[index];
          final isSelected = _isSameDay(date, selectedDate);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).substring(0, 1),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.black87
                          : AppTheme.textLightColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    double progress,
    int completed,
    int total,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    context.l10n.dailyProgress,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.completedCount(completed, total),
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _getProgressMessage(context, progress, total),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.textLightColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppTheme.dividerColor,
                color: AppTheme.primaryColor,
                minHeight: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String badgeText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitCard(Habit habit, bool isCompleted, {Key? key}) {
    //check if date is future date
    bool isFutureDate = selectedDate.isAfter(DateTime.now());

    return GestureDetector(
      key: key,
      onTap: () => context.push('/details/${habit.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (isFutureDate) {
                  //show message
                  context.showSnackBar(
                    context.l10n.youCannotCompleteFutureDates,
                    color: Colors.red,
                  );
                  return;
                }

                ref
                    .read(habitListProvider.notifier)
                    .toggleHabitCompletion(habit.id, selectedDate);
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: isCompleted
                        ? AppTheme.primaryColor
                        : AppTheme.dividerColor,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCompleted
                          ? AppTheme.textLightColor
                          : AppTheme.textColor,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (habit.category.isNotEmpty) ...[
                    Text(
                      habit.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.textLightColor,
                        fontSize: 13,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (habit.isReminderEnabled &&
                        habit.notificationTime != null)
                      const SizedBox(height: 4),
                  ],
                  if (habit.isReminderEnabled && habit.notificationTime != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: isCompleted
                              ? AppTheme.dividerColor
                              : AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          TimeOfDay.fromDateTime(
                            habit.notificationTime!,
                          ).format(context),
                          style: TextStyle(
                            color: isCompleted
                                ? AppTheme.dividerColor
                                : AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Icon(
              habit.icon,
              color: isCompleted
                  ? AppTheme.dividerColor
                  : AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  String _getProgressMessage(BuildContext context, double progress, int total) {
    if (total == 0) return context.l10n.addHabitsToStart;
    if (progress == 0) return context.l10n.startDayHabit;
    if (progress < 0.5) return context.l10n.goodStart;
    if (progress < 1.0) return context.l10n.almostThere;
    return context.l10n.amazingJob;
  }
}
