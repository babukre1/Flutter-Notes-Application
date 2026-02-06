import 'package:flutter/material.dart';
import 'package:notes_application/api_client.dart';
import 'package:notes_application/main.dart';
import 'package:notes_application/note-editor-app.dart';
import 'package:notes_application/note_item.dart';

class NotesDashboard extends StatefulWidget {
  const NotesDashboard({super.key});

  @override
  State<NotesDashboard> createState() => _NotesDashboardState();
}

// notes_dashboard.dart

class _NotesDashboardState extends State<NotesDashboard> {
  List<NoteItem> _allNotes = []; // Original list from backend
  List<NoteItem> _filteredNotes = []; // List displayed on screen
  bool _isLoading = true;

  // Controller for the search input
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNotes();

    // Listen to search changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter logic
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _allNotes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _fetchNotes() async {
    try {
      final response = await ApiClient.dio.get("/notes");
      final List data = response.data;
      setState(() {
        _allNotes = data.map((n) => NoteItem.fromJson(n)).toList();
        _filteredNotes = _allNotes; // Initially show all
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching notes: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE96A25);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notes",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Functional Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: _searchController, // Attached controller
                  decoration: const InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Color(0xFF6B7280)),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),

            // Notes List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchNotes,
                      color: primaryColor,
                      child: _filteredNotes.isEmpty
                          ? const Center(child: Text("No notes found"))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: _filteredNotes.length,
                              itemBuilder: (context, index) {
                                final note = _filteredNotes[index];
                                return NoteCard(
                                  note: note,
                                  onTap: () async {
                                    // Navigate to Editor and refresh on return
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NoteEditorScreen(note: note),
                                      ),
                                    );
                                    _fetchNotes();
                                  },
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteEditorScreen()),
          );
          _fetchNotes();
        },
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),

      // Removed Bottom Navigation Bar Search Tab as requested
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.description, "Notes", isSelected: true),
            _buildNavItem(Icons.star_outline, "Favorites"),
            _buildNavItem(Icons.settings_outlined, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    final color = isSelected
        ? const Color(0xFFE96A25)
        : const Color(0xFF9CA3AF);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}

class NoteCard extends StatelessWidget {
  final NoteItem note;
  final VoidCallback onTap; // Add this

  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap, // Use the passed callback
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.star, color: Color(0xFFE96A25), size: 18),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                note.content,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                note.date.split('T')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
