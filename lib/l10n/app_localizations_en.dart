// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DailyHabits';

  @override
  String get home => 'Home';

  @override
  String get todayHabits => 'Today\'s Habits';

  @override
  String get completed => 'COMPLETED';

  @override
  String get left => 'left';

  @override
  String get dailyProgress => 'Daily Progress';

  @override
  String completedCount(int completed, int total) {
    return '$completed / $total completed';
  }

  @override
  String get keepItUp => 'Keep it up!';

  @override
  String get almostThere => 'Almost there! Keep it up.';

  @override
  String get greatJob =>
      'Great job! You\'ve completed all your habits for today.';

  @override
  String get addHabit => 'Add Habit';

  @override
  String get editHabit => 'Edit Habit';

  @override
  String get habitName => 'HABIT NAME';

  @override
  String get habitNameHint => 'e.g., Drink Water';

  @override
  String get selectIcon => 'SELECT ICON';

  @override
  String get reminder => 'Reminder';

  @override
  String get notificationTime => 'Notification Time';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get delete => 'Delete';

  @override
  String get deleteHabit => 'Delete Habit?';

  @override
  String get deleteHabitConfirm =>
      'Are you sure you want to delete this habit? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get reminders => 'Reminders';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get deleteAllDataConfirm =>
      'Are you sure you want to delete all your data? This includes all habits and their history.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get statistics => 'Statistics';

  @override
  String get weeklyCompletion => 'Weekly Completion';

  @override
  String get monthlyConsistency => 'Monthly Consistency';

  @override
  String get currentStreak => 'CURRENT STREAK';

  @override
  String get bestStreak => 'BEST STREAK';

  @override
  String get totalHabits => 'TOTAL HABITS';

  @override
  String get days => 'Days';

  @override
  String get habits => 'Habits';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get history => 'History';

  @override
  String habitHistory(String name) {
    return '$name History';
  }

  @override
  String get habitDetails => 'Habit Details';

  @override
  String get addHabitsToStart => 'Add some habits to get started!';

  @override
  String get startDayHabit => 'Start your day by completing a habit!';

  @override
  String get goodStart => 'Good start! Keep going.';

  @override
  String get amazingJob =>
      'Amazing job! You\'ve completed everything for today.';

  @override
  String get allHabitsDoneToday => 'All habits for today are completed!';

  @override
  String get edit => 'Edit';

  @override
  String get general => 'General';

  @override
  String get noStreakYet => 'No streak yet';

  @override
  String get newRecord => 'New Record!';

  @override
  String ofBest(String percentage) {
    return '$percentage% of best';
  }

  @override
  String get startYourJourney => 'Start your journey';

  @override
  String get allTimeRecord => 'All-time record';

  @override
  String get weeklyProgress => 'Weekly Progress';

  @override
  String daysCompletedThisWeek(int count, int total) {
    return '$count/$total days completed this week';
  }

  @override
  String get monthlyProgress => 'Monthly Progress';

  @override
  String get schedule => 'Schedule';

  @override
  String get everyDay => 'Every day';

  @override
  String get reminderDisabled => 'Reminder disabled';

  @override
  String get recentHistory => 'Recent History';

  @override
  String get seeAll => 'See all';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get pleaseEnterHabitName => 'Please enter a habit name';

  @override
  String get allDataDeleted => 'All data deleted';

  @override
  String leftCount(int count) {
    return '$count left';
  }

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get dataImported => 'Data imported successfully';

  @override
  String importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String couldNotLaunch(String url) {
    return 'Could not launch $url';
  }

  @override
  String vsLastWeek(int percentage) {
    return 'Vs last week ($percentage%)';
  }

  @override
  String get less => 'LESS';

  @override
  String get more => 'MORE';

  @override
  String get searchIcons => 'Search icons...';

  @override
  String get noIconsFound => 'No icons found matching your search';

  @override
  String get allIcons => 'All Icons';

  @override
  String get version => 'Version';

  @override
  String get aboutApp => 'About App';

  @override
  String get youCannotCompleteFutureDates => 'You cannot complete future dates';

  @override
  String get continueBtn => 'Continue';
}
