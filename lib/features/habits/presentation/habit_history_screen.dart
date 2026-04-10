import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'habit_notifier.dart';
import 'package:habit_tracker_app/core/extension/context.dart';

class HabitHistoryScreen extends ConsumerWidget {
  final String habitId;
  const HabitHistoryScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitListProvider);

    return habitsAsync.when(
      data: (habits) {
        final habit = habits.firstWhere(
          (h) => h.id == habitId,
          orElse: () => throw Exception('Habit not found'),
        );

        final sortedDates = List<DateTime>.from(habit.completedDates)
          ..sort((a, b) => b.compareTo(a));

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => context.pop(),
            ),
            title: Text(context.l10n.habitHistory(habit.name)),
          ),
          body: sortedDates.isEmpty
              ? Center(
                  child: Text(
                    context.l10n.noHistoryYet,
                    style: TextStyle(
                      color: context.textTheme.labelLarge?.color,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: context.isDarkMode ? 0.2 : 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('EEEE, MMMM d, yyyy').format(date),
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                            size: 30,
                          ),
                        ],
                      ),
                    );
                  },
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
}
