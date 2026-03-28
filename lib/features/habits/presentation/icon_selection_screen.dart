import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/habit_icons.dart';
import 'package:habit_tracker_app/core/extension/context.dart';

class IconSelectionScreen extends StatefulWidget {
  const IconSelectionScreen({super.key});

  @override
  State<IconSelectionScreen> createState() => _IconSelectionScreenState();
}

class _IconSelectionScreenState extends State<IconSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<IconData> _filteredIcons = [];

  @override
  void initState() {
    super.initState();
    _filteredIcons = HabitIcons.getAllIcons();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      if (_searchQuery.isEmpty) {
        _filteredIcons = HabitIcons.getAllIcons();
      } else {
        _filteredIcons = HabitIcons.searchByKeywords(_searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.selectIcon,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchIcons,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.textLightColor,
                ),
                filled: true,
                fillColor: AppTheme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: _filteredIcons.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.textLightColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noIconsFound,
                          style: const TextStyle(
                            color: AppTheme.textLightColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: _searchQuery.isEmpty
                        ? _buildCategorizedGrid(l10n)
                        : [_buildSearchGrid()],
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategorizedGrid(AppLocalizations l10n) {
    List<Widget> sections = [];

    HabitIcons.iconCategories.forEach((category, icons) {
      sections.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            category.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.textLightColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ),
      );

      sections.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            final icon = icons[index];
            return _buildIconTile(icon);
          },
        ),
      );
    });

    sections.add(const SizedBox(height: 40));
    return sections;
  }

  Widget _buildSearchGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredIcons.length,
      itemBuilder: (context, index) {
        final icon = _filteredIcons[index];
        return _buildIconTile(icon);
      },
    );
  }

  Widget _buildIconTile(IconData icon) {
    return GestureDetector(
      onTap: () => context.pop(icon.codePoint),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 28),
      ),
    );
  }
}
