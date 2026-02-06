import 'package:flutter/material.dart';
import 'package:notes_application/notes-list-home.dart';
// import 'package:notes_application/notes_list_home.dart'; // Import the new file
import 'package:notes_application/user-profile-screen.dart';

class NotesDashboard extends StatefulWidget {
  const NotesDashboard({super.key});

  @override
  State<NotesDashboard> createState() => _NotesDashboardState();
}

class _NotesDashboardState extends State<NotesDashboard> {
  int _currentIndex = 0;

  // The screens for each tab
  final List<Widget> _screens = [
    const NotesListHome(),
    const Center(child: Text("Favorites Screen")),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, fill: isSelected ? 1.0 : 0.0),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}
