import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../habits/data/habit_repository.dart';
import '../../habits/presentation/habit_notifier.dart';
import 'package:habit_tracker_app/core/extension/context.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../habits/domain/habit.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = ref
        .read(settingsServiceProvider)
        .areNotificationsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context.l10n.reminders),
            _buildSettingsGroup([
              _buildToggleItem(
                icon: Icons.notifications,
                title: context.l10n.notifications,
                subtitle: 'Daily habit reminders',
                value: _notificationsEnabled,
                onChanged: (val) async {
                  setState(() => _notificationsEnabled = val);
                  await ref
                      .read(settingsServiceProvider)
                      .setNotificationsEnabled(val);
                  ref.read(habitRepositoryProvider).rescheduleAllReminders();
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader(context.l10n.appearance),
            _buildThemeTile(context, ref),
            const SizedBox(height: 24),
            _buildSectionHeader(context.l10n.language),
            _buildLanguageTile(context, ref),
            const SizedBox(height: 24),
            _buildSectionHeader(context.l10n.dataManagement),
            _buildSettingsGroup([
              _buildNavigationItem(
                icon: Icons.file_upload_outlined,
                title: context.l10n.exportData,
                onTap: () => _exportData(),
              ),
              _buildNavigationItem(
                icon: Icons.file_download_outlined,
                title: context.l10n.importData,
                onTap: () => _importData(),
              ),
              _buildButtonItem(
                icon: Icons.delete_outline,
                title: context.l10n.deleteAllData,
                titleColor: Colors.red,
                onTap: () => _confirmDeleteAll(context),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader(context.l10n.aboutApp),
            _buildSettingsGroup([
              _buildInfoItem(
                icon: Icons.info_outline,
                title: context.l10n.version,
                trailing: '1.0.0',
              ),
              _buildNavigationItem(
                icon: Icons.privacy_tip_outlined,
                title: context.l10n.privacyPolicy,
                trailingIcon: Icons.open_in_new,
                onTap: () => _launchURL(
                  'https://raheeldevninja.github.io/habt-tap-legal-pages/privacy-policy.html',
                ),
              ),
              _buildNavigationItem(
                icon: Icons.description_outlined,
                title: context.l10n.termsOfService,
                trailingIcon: Icons.open_in_new,
                onTap: () => _launchURL(
                  'https://raheeldevninja.github.io/habt-tap-legal-pages/terms-of-service.html',
                ),
              ),
            ]),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      //color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    'HABITTAP',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: context.textTheme.labelLarge?.color,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final String currentThemeLabel = _getThemeLabel(currentTheme);

    return _buildSettingsGroup([
      _buildNavigationItem(
        icon: Icons.palette_outlined,
        title: context.l10n.theme,
        subtitle: currentThemeLabel,
        onTap: () => _showThemeDialog(context, ref, currentTheme),
      ),
    ]);
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return context.l10n.light;
      case ThemeMode.dark:
        return context.l10n.dark;
      case ThemeMode.system:
        return context.l10n.system;
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentTheme,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.theme),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              ref,
              context.l10n.system,
              ThemeMode.system,
              currentTheme,
              Icons.brightness_auto,
            ),
            _buildThemeOption(
              context,
              ref,
              context.l10n.light,
              ThemeMode.light,
              currentTheme,
              Icons.light_mode,
            ),
            _buildThemeOption(
              context,
              ref,
              context.l10n.dark,
              ThemeMode.dark,
              currentTheme,
              Icons.dark_mode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    ThemeMode mode,
    ThemeMode currentTheme,
    IconData icon,
  ) {
    final isSelected = currentTheme == mode;

    return ListTile(
      tileColor: Colors.transparent,
      leading: _buildIconContainer(
        icon,
        color: isSelected
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        iconColor: isSelected
            ? AppTheme.primaryColor
            : Theme.of(context).hintColor,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppTheme.primaryColor : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
          : null,
      onTap: () {
        ref.read(themeProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildLanguageTile(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final String currentLanguageLabel = _getLanguageLabel(currentLocale);

    return _buildSettingsGroup([
      _buildNavigationItem(
        icon: Icons.language,
        title: context.l10n.language,
        subtitle: currentLanguageLabel,
        onTap: () => _showLanguageDialog(context, ref, currentLocale),
      ),
    ]);
  }

  String _getLanguageLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.language),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              ref,
              'English',
              const Locale('en'),
              currentLocale,
            ),
            _buildLanguageOption(
              context,
              ref,
              'Deutsch',
              const Locale('de'),
              currentLocale,
            ),
            _buildLanguageOption(
              context,
              ref,
              'Español',
              const Locale('es'),
              currentLocale,
            ),
            _buildLanguageOption(
              context,
              ref,
              'Français',
              const Locale('fr'),
              currentLocale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    Locale locale,
    Locale currentLocale,
  ) {
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return ListTile(
      tileColor: Colors.transparent,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.language,
          color: isSelected
              ? context.primaryColor
              : context.textTheme.labelLarge?.color,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? context.primaryColor
              : context.colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
          : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: context.textTheme.labelLarge),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
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
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast) const Divider(height: 1, indent: 64),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: _buildIconContainer(icon),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: context.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            )
          : null,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    String? subtitle,
    IconData trailingIcon = Icons.chevron_right,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: _buildIconContainer(icon),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            )
          : null,
      trailing: Icon(
        trailingIcon,
        color: context.textTheme.labelLarge?.color,
        size: 20,
      ),
    );
  }

  Widget _buildButtonItem({
    required IconData icon,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    final effectiveTitleColor = titleColor ?? context.colorScheme.onSurface;
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: _buildIconContainer(
        icon,
        color: effectiveTitleColor.withValues(alpha: 0.1),
        iconColor: effectiveTitleColor,
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: effectiveTitleColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: effectiveTitleColor.withValues(alpha: 0.5),
        size: 14,
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String trailing,
  }) {
    return ListTile(
      leading: _buildIconContainer(icon),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        trailing,
        style: TextStyle(
          color: context.textTheme.labelLarge?.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, {Color? color, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? AppTheme.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor ?? AppTheme.primaryColor, size: 20),
    );
  }

  Future<void> _exportData() async {
    try {
      final habitsAsync = ref.read(habitListProvider);
      final habits = habitsAsync.valueOrNull ?? [];
      final jsonList = habits.map((h) => h.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/habits_backup.json');
      await file.writeAsString(jsonString);

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], subject: 'HabitTracker Backup'),
      );
    } catch (e) {
      if (mounted) {
        context.showSnackBar(context.l10n.exportFailed(e.toString()));
      }
    }
  }

  Future<void> _importData() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);

        final habits = jsonList.map((j) => Habit.fromJson(j)).toList();

        await ref.read(habitListProvider.notifier).importData(habits);

        if (mounted) {
          context.showSnackBar(context.l10n.dataImported);
        }
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar(context.l10n.importFailed(e.toString()));
      }
    }
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteAllData),
        content: Text(context.l10n.deleteAllDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.l10n.cancel,
              style: TextStyle(color: context.textTheme.labelLarge?.color),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(habitListProvider.notifier).deleteAll();
              if (context.mounted) Navigator.pop(context);
              if (context.mounted) {
                context.showSnackBar(context.l10n.allDataDeleted);
              }
            },
            child: Text(
              context.l10n.deleteAll,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        context.showSnackBar(context.l10n.couldNotLaunch(urlString));
      }
    }
  }
}
