import 'package:flutter/material.dart';
import 'package:notes_application/views/notes_list_home.dart';
import 'package:notes_application/views/user_profile_screen.dart';

class NotesDashboard extends StatefulWidget {
  const NotesDashboard({super.key});

  @override
  State<NotesDashboard> createState() => _NotesDashboardState();
}

class _NotesDashboardState extends State<NotesDashboard> {
  int _currentIndex = 0;

  // Store a single instance that gets reused
  late final NotesListHome _notesScreen;
  late final NotesListHome _favoritesScreen;
  late final SettingsScreen _settingsScreen;

  @override
  void initState() {
    super.initState();
    // Initialize screens once
    _notesScreen = NotesListHome(
      key: const ValueKey('notes'),
      showOnlyFavorites: false,
    );
    _favoritesScreen = NotesListHome(
      key: const ValueKey('favorites'),
      showOnlyFavorites: true,
    );
    _settingsScreen = const SettingsScreen(
      key: ValueKey('settings'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _notesScreen,
          _favoritesScreen,
          _settingsScreen,
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.description, "Notes", 0),
            _buildNavItem(Icons.star_outline, "Favorites", 1),
            _buildNavItem(Icons.settings_outlined, "Settings", 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? const Color(0xFFE96A25)
        : const Color(0xFF9CA3AF);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              fill: isSelected ? 1.0 : 0.0,
              grade: isSelected ? 700 : 400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}