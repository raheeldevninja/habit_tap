import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../habits/domain/habit.dart';
import '../../habits/presentation/habit_notifier.dart';
import 'package:habit_tracker_app/core/extension/context.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitListProvider);

    return habitsAsync.when(
      data: (habits) {
        // Calculate basic metrics
        final totalHabits = habits.length;
        final maxCurrentStreak = habits.isEmpty
            ? 0
            : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);

        // Weekly calculations
        final now = DateTime.now();
        final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfLastWeek =
            startOfThisWeek.subtract(const Duration(days: 7));

        double calculateCompletionRate(DateTime startOfWeek) {
          int totalExpected = 0;
          int totalCompleted = 0;

          for (int i = 0; i < 7; i++) {
            final day = startOfWeek.add(Duration(days: i));
            for (final habit in habits) {
              if (habit.frequency.contains(day.weekday)) {
                totalExpected++;
                if (habit.completedDates.any((d) => _isSameDay(d, day))) {
                  totalCompleted++;
                }
              }
            }
          }
          return totalExpected == 0 ? 0.0 : totalCompleted / totalExpected;
        }

        final thisWeekRate = calculateCompletionRate(startOfThisWeek);
        final lastWeekRate = calculateCompletionRate(startOfLastWeek);
        final weeklyDiff = thisWeekRate - lastWeekRate;

        // Daily bars for current week
        final dailyRates = List.generate(7, (i) {
          final day = startOfThisWeek.add(Duration(days: i));
          int dayExpected = 0;
          int dayCompleted = 0;
          for (final habit in habits) {
            if (habit.frequency.contains(day.weekday)) {
              dayExpected++;
              if (habit.completedDates.any((d) => _isSameDay(d, day))) {
                dayCompleted++;
              }
            }
          }
          return dayExpected == 0 ? 0.0 : dayCompleted / dayExpected;
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(
              context.l10n.statistics,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildWeeklyCompletionCard(
                  context,
                  thisWeekRate,
                  lastWeekRate,
                  weeklyDiff,
                  dailyRates,
                ),
                const SizedBox(height: 24),
                _buildMonthlyConsistencyCard(context, habits),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        context.l10n.currentStreak,
                        '${maxCurrentStreak} ${context.l10n.days}',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        context.l10n.totalHabits,
                        '${totalHabits} ${context.l10n.habits}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80), // Padding for bottom nav
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

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Widget _buildWeeklyCompletionCard(
    BuildContext context,
    double thisWeekRate,
    double lastWeekRate,
    double diff,
    List<double> dailyRates,
  ) {
    final percent = (thisWeekRate * 100).toInt();
    final lastPercent = (lastWeekRate * 100).toInt();
    final diffPercent = (diff * 100).abs().toInt();
    final isUp = diff >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
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
          Text(
            context.l10n.weeklyCompletion,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textLightColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isUp ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isUp ? AppTheme.primaryColor : Colors.red,
                          size: 14,
                        ),
                        Text(
                          '${isUp ? '+' : '-'}$diffPercent%',
                          style: TextStyle(
                            color: isUp ? AppTheme.primaryColor : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      context.l10n.vsLastWeek(lastPercent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textLightColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(context, context.l10n.mon[0], dailyRates[0]),
                _buildBar(context, context.l10n.tue[0], dailyRates[1]),
                _buildBar(context, context.l10n.wed[0], dailyRates[2]),
                _buildBar(context, context.l10n.thu[0], dailyRates[3]),
                _buildBar(context, context.l10n.fri[0], dailyRates[4]),
                _buildBar(context, context.l10n.sat[0], dailyRates[5]),
                _buildBar(context, context.l10n.sun[0], dailyRates[6]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, String day, double heightFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: 70 * heightFactor,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            color: AppTheme.textLightColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyConsistencyCard(
    BuildContext context,
    List<Habit> habits,
  ) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // We want to show a grid that represents the whole month.
    // 7 columns (Mon-Sun). We need to know which weekday the month starts on.
    final startWeekday = firstDayOfMonth.weekday; // 1 (Mon) to 7 (Sun)
    final totalCells = ((daysInMonth + startWeekday - 1) / 7).ceil() * 7;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
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
            children: [
              Expanded(
                child: Text(
                  context.l10n.monthlyConsistency,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(now),
                style: const TextStyle(
                  color: AppTheme.textLightColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Heatmap grid placeholder
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              final dayNumber = index - (startWeekday - 2);
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(now.year, now.month, dayNumber);

              // Calculate completion for this specific day
              int expected = 0;
              int completed = 0;
              for (final habit in habits) {
                if (habit.frequency.contains(date.weekday)) {
                  expected++;
                  if (habit.completedDates.any((d) => _isSameDay(d, date))) {
                    completed++;
                  }
                }
              }

              double rate = expected == 0 ? 0.0 : completed / expected;

              Color color = AppTheme.backgroundColor;
              if (rate > 0) {
                if (rate < 0.5) {
                  color = AppTheme.primaryColor.withValues(alpha: 0.3);
                } else if (rate < 1.0) {
                  color = AppTheme.primaryColor.withValues(alpha: 0.6);
                } else {
                  color = AppTheme.primaryColor;
                }
              }

              return Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                context.l10n.less,
                style: const TextStyle(
                  color: AppTheme.textLightColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(
                5,
                (index) => Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(
                      alpha: 0.2 * (index + 1),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.more,
                style: const TextStyle(
                  color: AppTheme.textLightColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
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
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textLightColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
