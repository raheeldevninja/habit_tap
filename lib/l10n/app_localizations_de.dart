// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'DailyHabits';

  @override
  String get home => 'Startseite';

  @override
  String get todayHabits => 'Heutige Gewohnheiten';

  @override
  String get completed => 'ABGESCHLOSSEN';

  @override
  String get left => 'übrig';

  @override
  String get dailyProgress => 'Täglicher Fortschritt';

  @override
  String completedCount(int completed, int total) {
    return '$completed / $total abgeschlossen';
  }

  @override
  String get keepItUp => 'Weiter so!';

  @override
  String get almostThere => 'Fast geschafft! Bleiben Sie dran.';

  @override
  String get greatJob =>
      'Gute Arbeit! Du hast alle deine Gewohnheiten für heute abgeschlossen.';

  @override
  String get addHabit => 'Gewohnheit hinzufügen';

  @override
  String get editHabit => 'Gewohnheit bearbeiten';

  @override
  String get habitName => 'NAME DER GEWOHNHEIT';

  @override
  String get habitNameHint => 'z.B. Wasser trinken';

  @override
  String get selectIcon => 'SYMBOL AUSWÄHLEN';

  @override
  String get reminder => 'Erinnerung';

  @override
  String get notificationTime => 'Benachrichtigungszeit';

  @override
  String get createHabit => 'Gewohnheit erstellen';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteHabit => 'Gewohnheit löschen?';

  @override
  String get deleteHabitConfirm =>
      'Bist du sicher, dass du diese Gewohnheit löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appearance => 'Aussehen';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get language => 'Sprache';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get importData => 'Daten importieren';

  @override
  String get deleteAllData => 'Alle Daten löschen';

  @override
  String get deleteAllDataConfirm =>
      'Bist du sicher, dass du alle deine Daten löschen möchtest? Dies umfasst alle Gewohnheiten und deren Verlauf.';

  @override
  String get deleteAll => 'Alles löschen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get statistics => 'Statistiken';

  @override
  String get weeklyCompletion => 'Wöchentlicher Abschluss';

  @override
  String get monthlyConsistency => 'Monatliche Beständigkeit';

  @override
  String get currentStreak => 'AKTUELLE SERIE';

  @override
  String get bestStreak => 'BESTE SERIE';

  @override
  String get totalHabits => 'GESAMT GEWOHNHEITEN';

  @override
  String get days => 'Tage';

  @override
  String get habits => 'Gewohnheiten';

  @override
  String get noHistoryYet => 'Noch kein Verlauf';

  @override
  String get history => 'Verlauf';

  @override
  String habitHistory(String name) {
    return '$name Verlauf';
  }

  @override
  String get habitDetails => 'Gewohnheitsdetails';

  @override
  String get addHabitsToStart =>
      'Fügen Sie einige Gewohnheiten hinzu, um zu beginnen!';

  @override
  String get startDayHabit =>
      'Beginnen Sie Ihren Tag, indem Sie eine Gewohnheit abschließen!';

  @override
  String get goodStart => 'Guter Start! Weiter so.';

  @override
  String get amazingJob => 'Großartige Arbeit! Sie haben heute alles erledigt.';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get general => 'Allgemein';

  @override
  String get noStreakYet => 'Noch keine Serie';

  @override
  String get newRecord => 'Neuer Rekord!';

  @override
  String ofBest(String percentage) {
    return '$percentage% von Bestleistung';
  }

  @override
  String get startYourJourney => 'Beginne deine Reise';

  @override
  String get allTimeRecord => 'Allzeit-Rekord';

  @override
  String get weeklyProgress => 'Wöchentlicher Fortschritt';

  @override
  String daysCompletedThisWeek(int count, int total) {
    return '$count/$total Tage abgeschlossen in dieser Woche';
  }

  @override
  String get monthlyProgress => 'Monatlicher Fortschritt';

  @override
  String get schedule => 'Zeitplan';

  @override
  String get everyDay => 'Jeden Tag';

  @override
  String get reminderDisabled => 'Erinnerung deaktiviert';

  @override
  String get recentHistory => 'Letzter Verlauf';

  @override
  String get seeAll => 'Alle sehen';

  @override
  String get mon => 'Mo';

  @override
  String get tue => 'Di';

  @override
  String get wed => 'Mi';

  @override
  String get thu => 'Do';

  @override
  String get fri => 'Fr';

  @override
  String get sat => 'Sa';

  @override
  String get sun => 'So';

  @override
  String get pleaseEnterHabitName =>
      'Bitte gib einen Namen für die Gewohnheit ein';

  @override
  String get allDataDeleted => 'Alle Daten gelöscht';

  @override
  String leftCount(int count) {
    return '$count übrig';
  }

  @override
  String exportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get dataImported => 'Daten erfolgreich importiert';

  @override
  String importFailed(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String couldNotLaunch(String url) {
    return 'Konnte $url nicht öffnen';
  }

  @override
  String vsLastWeek(int percentage) {
    return 'Im Vergleich zur letzten Woche ($percentage%)';
  }

  @override
  String get less => 'WENIGER';

  @override
  String get more => 'MEHR';

  @override
  String get searchIcons => 'Icons suchen...';

  @override
  String get noIconsFound => 'Keine passenden Icons gefunden';

  @override
  String get allIcons => 'Alle Icons';

  @override
  String get version => 'Version';

  @override
  String get aboutApp => 'Über die App';

  @override
  String get youCannotCompleteFutureDates =>
      'Du kannst keine zukünftigen Daten abschließen';
}
