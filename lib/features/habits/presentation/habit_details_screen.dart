import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/core/theme/app_theme.dart';
import 'package:habit_tracker_app/features/habits/domain/habit.dart';
import 'package:intl/intl.dart';
import 'habit_notifier.dart';
import 'package:habit_tracker_app/core/extension/context.dart';

class HabitDetailsScreen extends ConsumerWidget {
  final String habitId;
  const HabitDetailsScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitListProvider);

    return habitsAsync.when(
      data: (habits) {
        final habit = habits.firstWhere(
          (h) => h.id == habitId,
          orElse: () => throw Exception('Habit not found'),
        );

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, size: 32),
              onPressed: () => context.pop(),
            ),
            title: Text(context.l10n.habitDetails),
            actions: [
              TextButton(
                onPressed: () => context.push('/edit/${habit.id}'),
                child: Text(
                  context.l10n.edit,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeroSection(context, habit),
                const SizedBox(height: 32),
                _buildStreaksRow(context, habit),
                const SizedBox(height: 32),
                _buildWeeklyProgress(context, habit),
                const SizedBox(height: 32),
                _buildMonthlyHeatmap(context, habit),
                const SizedBox(height: 32),
                _buildSchedule(context, habit),
                const SizedBox(height: 32),
                _buildRecentHistory(context, habit),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, Habit habit) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(habit.icon, size: 40, color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 16),
        Text(habit.name, style: context.textTheme.headlineLarge),
        const SizedBox(height: 4),
        Text(
          habit.category.isNotEmpty ? habit.category : context.l10n.general,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStreaksRow(BuildContext context, Habit habit) {
    // Current Streak Trend Logic
    String currentStreakTrend;
    Color currentStreakTrendColor;
    IconData currentStreakTrendIcon;

    if (habit.currentStreak == 0) {
      currentStreakTrend = context.l10n.noStreakYet;
      currentStreakTrendColor = AppTheme.textLightColor;
      currentStreakTrendIcon = Icons.info_outline;
    } else if (habit.currentStreak >= habit.bestStreak &&
        habit.bestStreak > 0) {
      currentStreakTrend = context.l10n.newRecord;
      currentStreakTrendColor = AppTheme.primaryColor;
      currentStreakTrendIcon = Icons.star;
    } else {
      final percentage = habit.bestStreak > 0
          ? (habit.currentStreak / habit.bestStreak * 100).toStringAsFixed(0)
          : '0';
      currentStreakTrend = context.l10n.ofBest(percentage);
      currentStreakTrendColor = AppTheme.primaryColor;
      currentStreakTrendIcon = Icons.trending_up;
    }

    // Best Streak Trend Logic
    String bestStreakTrend;
    Color bestStreakTrendColor;
    IconData bestStreakTrendIcon;

    if (habit.bestStreak == 0) {
      bestStreakTrend = context.l10n.startYourJourney;
      bestStreakTrendColor = AppTheme.textLightColor;
      bestStreakTrendIcon = Icons.play_arrow;
    } else {
      bestStreakTrend = context.l10n.allTimeRecord;
      bestStreakTrendColor = AppTheme.primaryColor;
      bestStreakTrendIcon = Icons.emoji_events;
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context: context,
            label: context.l10n.currentStreak.toUpperCase(),
            value: '${habit.currentStreak} days',
            trend: currentStreakTrend,
            trendColor: currentStreakTrendColor,
            trendIcon: currentStreakTrendIcon,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context: context,
            label: context.l10n.bestStreak.toUpperCase(),
            value: '${habit.bestStreak} days',
            trend: bestStreakTrend,
            trendColor: bestStreakTrendColor,
            trendIcon: bestStreakTrendIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String label,
    required String value,
    required String trend,
    required Color trendColor,
    required IconData trendIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.textTheme.labelLarge),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: context.textTheme.headlineLarge),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(trendIcon, size: 14, color: trendColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  trend,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge!.copyWith(
                    color: trendColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress(BuildContext context, Habit habit) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final completions = List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      return habit.completedDates.any((d) => _isSameDay(d, day));
    });

    int count = completions.where((e) => e).length;
    int expectedCount = 0;
    for (int i = 0; i < 7; i++) {
      if (habit.frequency.contains(i + 1)) expectedCount++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.weeklyProgress, style: context.textTheme.titleMedium),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  return Column(
                    children: [
                      Text(days[index], style: context.textTheme.labelLarge),
                      const SizedBox(height: 12),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: completions[index]
                              ? AppTheme.primaryColor
                              : AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.daysCompletedThisWeek(count, expectedCount),
                style: context.textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyHeatmap(BuildContext context, Habit habit) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday;
    final totalCells = ((daysInMonth + startWeekday - 1) / 7).ceil() * 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.monthlyProgress,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: totalCells,
                itemBuilder: (context, index) {
                  final dayNumber = index - (startWeekday - 2);
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox.shrink();
                  }

                  final date = DateTime(now.year, now.month, dayNumber);
                  final isCompleted = habit.completedDates.any(
                    (d) => _isSameDay(d, date),
                  );
                  final isExpected = habit.frequency.contains(date.weekday);

                  Color boxColor = AppTheme.backgroundColor;
                  if (isCompleted) {
                    boxColor = AppTheme.primaryColor;
                  } else if (isExpected && date.isBefore(now)) {
                    boxColor = Colors.red.withValues(alpha: 0.1);
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM 1').format(firstDayOfMonth),
                    style: context.textTheme.labelLarge!.copyWith(
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d').format(lastDayOfMonth),
                    style: context.textTheme.labelLarge!.copyWith(
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSchedule(BuildContext context, Habit habit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.schedule, style: context.textTheme.titleMedium),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.reminder,
                      style: context.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    habit.isReminderEnabled
                        ? Text(
                            habit.frequency.length == 7
                                ? context.l10n.everyDay
                                : habit.frequency
                                      .map((d) => _getWeekdayName(context, d))
                                      .join(', '),
                            style: context.textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  !habit.isReminderEnabled
                      ? context.l10n.reminderDisabled
                      : habit.notificationTime != null
                      ? TimeOfDay.fromDateTime(
                          habit.notificationTime!,
                        ).format(context)
                      : '08:00 AM',
                  style: TextStyle(
                    color: !habit.isReminderEnabled
                        ? AppTheme.textLightColor
                        : Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentHistory(BuildContext context, Habit habit) {
    final sortedDates = List<DateTime>.from(habit.completedDates)
      ..sort((a, b) => b.compareTo(a));
    final displayDates = sortedDates.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.recentHistory,
              style: context.textTheme.titleMedium,
            ),
            if (sortedDates.length > 3)
              TextButton(
                onPressed: () => context.push('/history/${habit.id}'),
                child: Text(
                  context.l10n.seeAll,
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (displayDates.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              context.l10n.noHistoryYet,
              style: context.textTheme.labelMedium,
            ),
          ),
        ...displayDates.map((date) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(date),
                  style: context.textTheme.bodyMedium,
                ),
                const Spacer(),
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  String _getWeekdayName(BuildContext context, int weekday) {
    switch (weekday) {
      case 1:
        return context.l10n.mon;
      case 2:
        return context.l10n.tue;
      case 3:
        return context.l10n.wed;
      case 4:
        return context.l10n.thu;
      case 5:
        return context.l10n.fri;
      case 6:
        return context.l10n.sat;
      case 7:
        return context.l10n.sun;
      default:
        return '';
    }
  }
}
