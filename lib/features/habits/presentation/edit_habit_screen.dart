import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/core/extension/context.dart';
import 'package:habit_tracker_app/core/theme/app_theme.dart';
import '../domain/habit.dart';
import 'habit_notifier.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  final String habitId;
  const EditHabitScreen({super.key, required this.habitId});

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  late TextEditingController _nameController;
  late int _selectedIconCode;
  late bool _isReminderEnabled;
  late TimeOfDay _notificationTime;
  Habit? _habit;

  final List<IconData> _quickIcons = [
    Icons.water_drop,
    Icons.fitness_center,
    Icons.menu_book,
    Icons.self_improvement,
    Icons.nightlight_round,
    Icons.restaurant,
    Icons.directions_run,
    Icons.psychology,
    Icons.savings,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    // Defer initialization until after build or use a provider to get the habit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final habitsAsync = ref.read(habitListProvider);
      final habit = habitsAsync.valueOrNull?.firstWhere(
        (h) => h.id == widget.habitId,
        orElse: () => throw Exception('Habit not found'),
      );
      if (habit != null) {
        _initializeState(habit);
      }
    });
  }

  void _initializeState(Habit h) {
    if (_habit == null) {
      _habit = h;
      _nameController.text = h.name;
      _selectedIconCode = h.iconCode;
      _isReminderEnabled = h.isReminderEnabled;
      if (h.notificationTime != null) {
        _notificationTime = TimeOfDay.fromDateTime(h.notificationTime!);
      } else {
        _notificationTime = const TimeOfDay(hour: 8, minute: 0);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (_nameController.text.trim().isEmpty) {
      context.showSnackBar(context.l10n.pleaseEnterHabitName);

      return;
    }

    final updatedHabit = _habit!.copyWith(
      name: _nameController.text.trim(),
      iconCode: _selectedIconCode,
      isReminderEnabled: _isReminderEnabled,
      notificationTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _notificationTime.hour,
        _notificationTime.minute,
      ),
    );

    ref.read(habitListProvider.notifier).updateHabit(updatedHabit);
    context.pop();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colorScheme.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: context.colorScheme.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.deleteHabit,
                  style: context.textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.deleteHabitConfirm,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.textTheme.labelLarge?.color,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(habitListProvider.notifier)
                          .deleteHabit(widget.habitId);
                      Navigator.of(context).pop(); // dialog
                      context.go('/'); // Back to home after delete
                    },
                    child: Text(
                      context.l10n.delete,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: context.colorScheme.outlineVariant
                          .withValues(alpha: 0.1),
                      foregroundColor: context.colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      context.l10n.cancel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitListProvider);

    return habitsAsync.when(
      data: (habits) {
        final habit = habits.firstWhere(
          (h) => h.id == widget.habitId,
          orElse: () => throw Exception('Habit not found'),
        );

        // Initial check to avoid using uninitialized variables in build
        if (_habit == null) {
          _initializeState(habit);
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => context.pop(),
            ),
            title: Text(context.l10n.editHabit),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel(context.l10n.habitName),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: context.l10n.habitNameHint,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionLabel(
                  context.l10n.selectIcon,
                  previewIconCode: _selectedIconCode,
                ),
                const SizedBox(height: 8),
                _buildIconSelectionGrid(),
                const SizedBox(height: 24),
                _buildReminderSection(),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.error
                                .withValues(alpha: 0.1),
                            foregroundColor: context.colorScheme.error,
                          ),
                          onPressed: _confirmDelete,
                          child: Text(context.l10n.delete),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveHabit,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(context.l10n.saveChanges, maxLines: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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

  Widget _buildSectionLabel(String label, {int? previewIconCode}) {
    return Row(
      children: [
        Text(label, style: context.textTheme.labelLarge),
        if (previewIconCode != null) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconData(previewIconCode, fontFamily: 'MaterialIcons'),
              color: AppTheme.primaryColor,
              size: 16,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIconSelectionGrid() {
    final bool isCustomIcon = !_quickIcons.any(
      (icon) => icon.codePoint == _selectedIconCode,
    );
    final int itemCount = _quickIcons.length + (isCustomIcon ? 2 : 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: context.isDarkMode ? 0.2 : 0.02,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == itemCount - 1) {
            // "More" button always last
            return GestureDetector(
              onTap: () async {
                final result = await context.push('/select-icon');
                if (result != null && result is int) {
                  setState(() {
                    _selectedIconCode = result;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: context.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.grid_view_rounded,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'More',
                      style: context.textTheme.labelSmall!.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (isCustomIcon && index == itemCount - 2) {
            // Custom icon slot
            return _buildIconTile(
              IconData(_selectedIconCode, fontFamily: 'MaterialIcons'),
              true,
            );
          }

          final icon = _quickIcons[index];
          final isSelected = _selectedIconCode == icon.codePoint;
          return _buildIconTile(icon, isSelected);
        },
      ),
    );
  }

  Widget _buildIconTile(IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIconCode = icon.codePoint;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withValues(alpha: 0.2)
              : context.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppTheme.primaryColor, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? context.primaryColor
              : context.textTheme.labelLarge?.color,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildReminderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: context.isDarkMode ? 0.2 : 0.02,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  context.l10n.reminder,
                  style: context.textTheme.bodyLarge,
                ),
              ),
              Switch(
                value: _isReminderEnabled,
                onChanged: (value) {
                  setState(() {
                    _isReminderEnabled = value;
                  });
                },
              ),
            ],
          ),
          if (_isReminderEnabled) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.notificationTime,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: context.textTheme.labelLarge?.color,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _notificationTime.format(context),
                          style: context.textTheme.titleSmall,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: context.textTheme.labelLarge?.color,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
