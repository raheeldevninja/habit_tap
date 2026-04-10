// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'DailyHabits';

  @override
  String get home => 'Inicio';

  @override
  String get todayHabits => 'Hábitos de Hoy';

  @override
  String get completed => 'COMPLETADO';

  @override
  String get left => 'restantes';

  @override
  String get dailyProgress => 'Progreso Diario';

  @override
  String completedCount(int completed, int total) {
    return '$completed / $total completados';
  }

  @override
  String get keepItUp => '¡Sigue así!';

  @override
  String get almostThere => '¡Ya casi estás! No te rindas.';

  @override
  String get greatJob =>
      '¡Buen trabajo! Has completado todos tus hábitos por hoy.';

  @override
  String get addHabit => 'Añadir Hábito';

  @override
  String get editHabit => 'Editar Hábito';

  @override
  String get habitName => 'NOMBRE DEL HÁBITO';

  @override
  String get habitNameHint => 'p. ej., Beber Agua';

  @override
  String get selectIcon => 'SELECCIONAR ICONO';

  @override
  String get reminder => 'Recordatorio';

  @override
  String get notificationTime => 'Hora de Notificación';

  @override
  String get createHabit => 'Crear Hábito';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteHabit => '¿Eliminar Hábito?';

  @override
  String get deleteHabitConfirm =>
      '¿Estás seguro de que quieres eliminar este hábito? Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get settings => 'Ajustes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get language => 'Idioma';

  @override
  String get dataManagement => 'Gestión de Datos';

  @override
  String get exportData => 'Exportar Datos';

  @override
  String get importData => 'Importar Datos';

  @override
  String get deleteAllData => 'Eliminar Todos los Datos';

  @override
  String get deleteAllDataConfirm =>
      '¿Estás seguro de que quieres eliminar todos tus datos? Esto incluye todos los hábitos y su historial.';

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get weeklyCompletion => 'Cumplimiento Semanal';

  @override
  String get monthlyConsistency => 'Consistencia Mensual';

  @override
  String get currentStreak => 'RACHA ACTUAL';

  @override
  String get bestStreak => 'MEJOR RACHA';

  @override
  String get totalHabits => 'TOTAL DE HÁBITOS';

  @override
  String get days => 'Días';

  @override
  String get habits => 'Hábitos';

  @override
  String get noHistoryYet => 'Aún no hay historial';

  @override
  String get history => 'Historial';

  @override
  String habitHistory(String name) {
    return 'Historial de $name';
  }

  @override
  String get habitDetails => 'Detalles del Hábito';

  @override
  String get addHabitsToStart => '¡Añade algunos hábitos para empezar!';

  @override
  String get startDayHabit => '¡Empieza el día completando un hábito!';

  @override
  String get goodStart => '¡Buen comienzo! Sigue así.';

  @override
  String get amazingJob => '¡Increíble trabajo! Has completado todo por hoy.';

  @override
  String get edit => 'Editar';

  @override
  String get general => 'General';

  @override
  String get noStreakYet => 'Aún no hay rachas';

  @override
  String get newRecord => '¡Nuevo Récord!';

  @override
  String ofBest(String percentage) {
    return '$percentage% de lo mejor';
  }

  @override
  String get startYourJourney => 'Comienza tu viaje';

  @override
  String get allTimeRecord => 'Récord histórico';

  @override
  String get weeklyProgress => 'Cumplimiento Semanal';

  @override
  String daysCompletedThisWeek(int count, int total) {
    return '$count/$total días completados esta semana';
  }

  @override
  String get monthlyProgress => 'Progreso Mensual';

  @override
  String get schedule => 'Horario';

  @override
  String get everyDay => 'Cada día';

  @override
  String get reminderDisabled => 'Recordatorio desactivado';

  @override
  String get recentHistory => 'Historial Reciente';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mié';

  @override
  String get thu => 'Jue';

  @override
  String get fri => 'Vie';

  @override
  String get sat => 'Sáb';

  @override
  String get sun => 'Dom';

  @override
  String get pleaseEnterHabitName =>
      'Por favor, introduce un nombre para el hábito';

  @override
  String get allDataDeleted => 'Todos los datos eliminados';

  @override
  String leftCount(int count) {
    return '$count restantes';
  }

  @override
  String exportFailed(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get dataImported => 'Datos importados con éxito';

  @override
  String importFailed(String error) {
    return 'Error al importar: $error';
  }

  @override
  String couldNotLaunch(String url) {
    return 'No se pudo abrir $url';
  }

  @override
  String vsLastWeek(int percentage) {
    return 'Vs semana pasada ($percentage%)';
  }

  @override
  String get less => 'MENOS';

  @override
  String get more => 'MÁS';

  @override
  String get searchIcons => 'Buscar iconos...';

  @override
  String get noIconsFound => 'No se encontraron iconos';

  @override
  String get allIcons => 'Todos los iconos';

  @override
  String get version => 'Versión';

  @override
  String get aboutApp => 'Acerca de la Aplicación';

  @override
  String get youCannotCompleteFutureDates =>
      'No puedes completar fechas futuras';
}
