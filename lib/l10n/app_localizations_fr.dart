// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'DailyHabits';

  @override
  String get home => 'Accueil';

  @override
  String get todayHabits => 'Habitudes d\'Aujourd\'hui';

  @override
  String get completed => 'TERMINÉ';

  @override
  String get left => 'restantes';

  @override
  String get dailyProgress => 'Progrès Quotidien';

  @override
  String completedCount(int completed, int total) {
    return '$completed / $total terminés';
  }

  @override
  String get keepItUp => 'Continuez comme ça !';

  @override
  String get almostThere => 'Presque là ! Continuez comme ça.';

  @override
  String get greatJob =>
      'Bon travail ! Vous avez terminé toutes vos habitudes pour aujourd\'hui.';

  @override
  String get addHabit => 'Ajouter une Habitude';

  @override
  String get editHabit => 'Modifier l\'Habitude';

  @override
  String get habitName => 'NOM DE L\'HABITUDE';

  @override
  String get habitNameHint => 'ex: Boire de l\'eau';

  @override
  String get selectIcon => 'SÉLECTIONNER L\'ICÔNE';

  @override
  String get reminder => 'Rappel';

  @override
  String get notificationTime => 'Heure de Notification';

  @override
  String get createHabit => 'Créer l\'Habitude';

  @override
  String get saveChanges => 'Enregistrer les Modifications';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteHabit => 'Supprimer l\'Habitude ?';

  @override
  String get deleteHabitConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette habitude ? Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get settings => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get reminders => 'Rappels';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Langue';

  @override
  String get dataManagement => 'Gestion des Données';

  @override
  String get exportData => 'Exporter les Données';

  @override
  String get importData => 'Importer les Données';

  @override
  String get deleteAllData => 'Supprimer Toutes les Données';

  @override
  String get deleteAllDataConfirm =>
      'Êtes-vous sûr de vouloir supprimer toutes vos données ? Cela inclut toutes les habitudes et leur historique.';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get statistics => 'Statistiques';

  @override
  String get weeklyCompletion => 'Complétion Hebdomadaire';

  @override
  String get monthlyConsistency => 'Consistance Mensuelle';

  @override
  String get currentStreak => 'SÉRIE ACTUELLE';

  @override
  String get bestStreak => 'MEILLEURE SÉRIE';

  @override
  String get totalHabits => 'TOTAL DES HABITUDES';

  @override
  String get days => 'Jours';

  @override
  String get habits => 'Habitudes';

  @override
  String get noHistoryYet => 'Pas encore d\'historique';

  @override
  String get history => 'Historique';

  @override
  String habitHistory(String name) {
    return 'Historique de $name';
  }

  @override
  String get habitDetails => 'Détails de l\'Habitude';

  @override
  String get addHabitsToStart => 'Ajoutez des habitudes pour commencer !';

  @override
  String get startDayHabit =>
      'Commencez votre journée en complétant une habitude !';

  @override
  String get goodStart => 'Bon début ! Continuez.';

  @override
  String get amazingJob =>
      'Excellent travail ! Vous avez tout terminé pour aujourd\'hui.';

  @override
  String get allHabitsDoneToday =>
      'Toutes les habitudes d\'aujourd\'hui sont terminées !';

  @override
  String get edit => 'Modifier';

  @override
  String get general => 'Général';

  @override
  String get noStreakYet => 'Pas encore de série';

  @override
  String get newRecord => 'Nouveau Record !';

  @override
  String ofBest(String percentage) {
    return '$percentage% de la meilleure';
  }

  @override
  String get startYourJourney => 'Commencez votre voyage';

  @override
  String get allTimeRecord => 'Record historique';

  @override
  String get weeklyProgress => 'Complétion Hebdomadaire';

  @override
  String daysCompletedThisWeek(int count, int total) {
    return '$count/$total jours terminés cette semaine';
  }

  @override
  String get monthlyProgress => 'Progrès Mensuel';

  @override
  String get schedule => 'Planning';

  @override
  String get everyDay => 'Chaque jour';

  @override
  String get reminderDisabled => 'Rappel désactivé';

  @override
  String get recentHistory => 'Historique Récent';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mer';

  @override
  String get thu => 'Jeu';

  @override
  String get fri => 'Ven';

  @override
  String get sat => 'Sam';

  @override
  String get sun => 'Dim';

  @override
  String get pleaseEnterHabitName => 'Veuillez entrer un nom d\'habitude';

  @override
  String get allDataDeleted => 'Toutes les données ont été supprimées';

  @override
  String leftCount(int count) {
    return '$count restants';
  }

  @override
  String exportFailed(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get dataImported => 'Données importées avec succès';

  @override
  String importFailed(String error) {
    return 'Échec de l\'importation : $error';
  }

  @override
  String couldNotLaunch(String url) {
    return 'Impossible d\'ouvrir $url';
  }

  @override
  String vsLastWeek(int percentage) {
    return 'Par rapport à la semaine dernière ($percentage%)';
  }

  @override
  String get less => 'MOINS';

  @override
  String get more => 'PLUS';

  @override
  String get searchIcons => 'Rechercher des icônes...';

  @override
  String get noIconsFound => 'Aucune icône trouvée';

  @override
  String get allIcons => 'Toutes les icônes';

  @override
  String get version => 'Version';

  @override
  String get aboutApp => 'À Propos de l\'App';

  @override
  String get youCannotCompleteFutureDates =>
      'Vous ne pouvez pas compléter les dates futures';

  @override
  String get continueBtn => 'Continuer';
}
