import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
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
              icon: const Icon(Icons.chevron_left, size: 32),
              onPressed: () => context.pop(),
            ),
            title: Text(
              context.l10n.habitHistory(habit.name),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: sortedDates.isEmpty
              ? Center(
                  child: Text(
                    context.l10n.noHistoryYet,
                    style: const TextStyle(
                      color: AppTheme.textLightColor,
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
                          Expanded(
                            child: Text(
                              DateFormat('EEEE, MMMM d, yyyy').format(date),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppTheme.textColor,
                              ),
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
