import 'package:flutter/material.dart';
import 'package:habit_tracker_app/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker_app/features/habits/domain/habit.dart';
import 'package:habit_tracker_app/features/habits/presentation/habit_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker_app/core/extension/context.dart';
import 'package:confetti/confetti.dart';
import 'package:habit_tracker_app/features/habits/presentation/widgets/celebration_dialog.dart';

enum HabitListItemType { header, habit }

class HabitListItem {
  final HabitListItemType type;
  final Habit? habit;
  final String? title;
  final String? badge;
  final bool isCompleted;

  HabitListItem.habit(this.habit, this.isCompleted)
    : type = HabitListItemType.habit,
      title = null,
      badge = null;
  HabitListItem.header(this.title, {this.badge})
    : type = HabitListItemType.header,
      habit = null,
      isCompleted = false;

  String get id =>
      type == HabitListItemType.habit ? "${habit!.id}_$isCompleted" : "header_$title";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitListItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class HabitsMainScreen extends ConsumerStatefulWidget {
  const HabitsMainScreen({super.key});

  @override
  ConsumerState<HabitsMainScreen> createState() => _HabitsMainScreenState();
}

class _HabitsMainScreenState extends ConsumerState<HabitsMainScreen> {
  DateTime selectedDate = DateTime.now();
  late ConfettiController _confettiController;
  late PageController _calendarPageController;
  final int _initialPage = 5000;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<HabitListItem> _displayItems = [];
  final Map<String, DateTime> _lastToggled = {};

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _calendarPageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _calendarPageController.dispose();
    super.dispose();
  }

  List<HabitListItem> _flattenHabits(List<Habit> habits) {
    if (habits.isEmpty) return [];

    final originalOrder = {
      for (var i = 0; i < habits.length; i++) habits[i].id: i
    };

    int compareHabits(Habit a, Habit b) {
      final timeA = _lastToggled[a.id];
      final timeB = _lastToggled[b.id];

      if (timeA != null && timeB != null) {
        return timeB.compareTo(timeA);
      } else if (timeA != null) {
        return -1;
      } else if (timeB != null) {
        return 1;
      } else {
        return originalOrder[a.id]!.compareTo(originalOrder[b.id]!);
      }
    }

    final activeHabitsForDay = habits
        .where(
          (h) =>
              h.frequency.contains(selectedDate.weekday) &&
              !h.completedDates.any((d) => _isSameDay(d, selectedDate)),
        )
        .toList()
      ..sort(compareHabits);

    final completedHabitsForDay = habits
        .where(
          (h) =>
              h.frequency.contains(selectedDate.weekday) &&
              h.completedDates.any((d) => _isSameDay(d, selectedDate)),
        )
        .toList()
      ..sort(compareHabits);

    final List<HabitListItem> items = [];

    if (activeHabitsForDay.isNotEmpty) {
      items.add(
        HabitListItem.header(
          context.l10n.todayHabits,
          badge: "${activeHabitsForDay.length} ${context.l10n.left}",
        ),
      );
      items.addAll(activeHabitsForDay.map((h) => HabitListItem.habit(h, false)));
    }

    if (completedHabitsForDay.isNotEmpty) {
      items.add(HabitListItem.header(context.l10n.completed));
      items.addAll(completedHabitsForDay.map((h) => HabitListItem.habit(h, true)));
    }

    return items;
  }

  void _syncListItemChanges(List<HabitListItem> newList) {
    if (_listKey.currentState == null) {
      _displayItems = List.from(newList);
      return;
    }

    // 1. Remove items that are in _displayItems but NOT in newList
    for (int i = _displayItems.length - 1; i >= 0; i--) {
      final currentItem = _displayItems[i];
      if (!newList.any((element) => element.id == currentItem.id)) {
        final removedItem = _displayItems.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildAnimatedItem(removedItem, animation),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    // 2. Insert and sync items
    for (int i = 0; i < newList.length; i++) {
      final newItem = newList[i];
      if (i >= _displayItems.length || _displayItems[i].id != newItem.id) {
        _displayItems.insert(i, newItem);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      } else {
        _displayItems[i] = newItem;
      }
    }
  }

  Widget _buildAnimatedItem(HabitListItem item, Animation<double> animation) {
    if (item.type == HabitListItemType.header) {
      return FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: item.badge != null
                ? _buildSectionHeader(item.title!, item.badge!)
                : Text(
                    item.title!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.textTheme.labelLarge?.color,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
        ),
      );
    } else {
      final habit = item.habit!;
      final isCompleted = item.isCompleted;

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in/out from right
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
          ),
          child: _buildHabitCard(habit, isCompleted, key: ValueKey("${habit.id}_$isCompleted")),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitListProvider);

    ref.listen(habitListProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        final habits = next.value!;

        // Handle celebration trigger
        final activeCount = habits
            .where(
              (h) =>
                  h.frequency.contains(selectedDate.weekday) &&
                  !h.completedDates.any((d) => _isSameDay(d, selectedDate)),
            )
            .length;
        final completedCount = habits
            .where(
              (h) =>
                  h.frequency.contains(selectedDate.weekday) &&
                  h.completedDates.any((d) => _isSameDay(d, selectedDate)),
            )
            .length;

        if (activeCount == 0 && completedCount > 0) {
          bool wasIncompleteBefore = false;
          if (previous != null && previous.hasValue && previous.value != null) {
            final prevHabits = previous.value!;
            final prevActiveCount = prevHabits
                .where(
                  (h) =>
                      h.frequency.contains(selectedDate.weekday) &&
                      !h.completedDates.any((d) => _isSameDay(d, selectedDate)),
                )
                .length;
            if (prevActiveCount > 0) wasIncompleteBefore = true;
          }
          if (wasIncompleteBefore) {
            _confettiController.play();
            CelebrationDialog.show(context);
          }
        }

        // Handle List Item Animations
        _syncListItemChanges(_flattenHabits(habits));
      }
    });

    // Populate initial items if empty and we have data
    if (_displayItems.isEmpty &&
        habitsAsync.hasValue &&
        habitsAsync.value != null) {
      _displayItems = _flattenHabits(habitsAsync.value!);
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildCalendarStrip(),
                const SizedBox(height: 24),
                habitsAsync.when(
                  data: (habits) {
                    final habitsForDay = habits
                        .where(
                          (h) => h.frequency.contains(selectedDate.weekday),
                        )
                        .toList();
                    final completedHabitsForDay = habitsForDay
                        .where(
                          (h) => h.completedDates.any(
                            (d) => _isSameDay(d, selectedDate),
                          ),
                        )
                        .toList();

                    final totalForDay = habitsForDay.length;
                    final progress = totalForDay == 0
                        ? 0.0
                        : completedHabitsForDay.length / totalForDay;

                    return _buildProgressCard(
                      context,
                      progress,
                      completedHabitsForDay.length,
                      totalForDay,
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _displayItems.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index, animation) {
                      return _buildAnimatedItem(
                        _displayItems[index],
                        animation,
                      );
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 100,
                colors: const [
                  AppTheme.primaryColor,
                  Colors.blue,
                  Colors.orange,
                  Colors.purple,
                  Colors.pink,
                ],
              ),
            ),
          ],
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Text(
              DateFormat('MMMM yyyy').format(selectedDate),
              key: ValueKey(DateFormat('MM').format(selectedDate)),
              style: context.textTheme.headlineLarge,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  _calendarPageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  _calendarPageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: _calendarPageController,
        onPageChanged: (index) {
          final int weeksOffset = index - _initialPage;
          // Calculate the same weekday in the new week
          final int currentWeekday = selectedDate.weekday;
          final DateTime startOfTargetWeek = DateTime.now()
              .subtract(Duration(days: DateTime.now().weekday - 1))
              .add(Duration(days: weeksOffset * 7));

          setState(() {
            _lastToggled.clear();
            selectedDate = startOfTargetWeek.add(
              Duration(days: currentWeekday - 1),
            );
          });
        },
        itemBuilder: (context, pageIndex) {
          final int weeksOffset = pageIndex - _initialPage;
          final DateTime startOfThisWeek = DateTime.now()
              .subtract(Duration(days: DateTime.now().weekday - 1))
              .add(Duration(days: weeksOffset * 7));

          final List<DateTime> weekDates = List.generate(
            7,
            (index) => startOfThisWeek.add(Duration(days: index)),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDates.map((date) {
                final isSelected = _isSameDay(date, selectedDate);
                final isToday = _isSameDay(date, DateTime.now());

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _lastToggled.clear();
                      selectedDate = date;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: 46,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : isToday
                          ? AppTheme.primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: isToday && !isSelected
                          ? Border.all(color: AppTheme.primaryColor, width: 1)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(date).substring(0, 1),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : context.textTheme.labelLarge?.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : context.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
          color: context.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: context.isDarkMode ? 0.2 : 0.04,
              ),
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
                    style: context.textTheme.titleMedium,
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
              style: context.textTheme.labelMedium,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: context.colorScheme.outlineVariant.withValues(
                  alpha: 0.2,
                ),
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
        Text(title, style: context.textTheme.titleMedium),
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
    bool isFutureDate = selectedDate.isAfter(DateTime.now());

    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/details/${habit.id}'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (!isCompleted)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (isFutureDate) {
                    context.showSnackBar(
                      context.l10n.youCannotCompleteFutureDates,
                      color: Colors.red,
                    );
                    return;
                  }
                  
                  _lastToggled[habit.id] = DateTime.now();

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
                          : context.colorScheme.outlineVariant,
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
                            ? context.textTheme.labelLarge?.color
                            : context.colorScheme.onSurface,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (habit.category.isNotEmpty) ...[
                      Text(
                        habit.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.textTheme.labelLarge?.color,
                          fontSize: 13,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                    if (habit.isReminderEnabled &&
                        habit.notificationTime != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: isCompleted
                                ? context.colorScheme.outlineVariant
                                : AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            TimeOfDay.fromDateTime(
                              habit.notificationTime!,
                            ).format(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: isCompleted
                                  ? context.colorScheme.outlineVariant
                                  : context.textTheme.labelLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
