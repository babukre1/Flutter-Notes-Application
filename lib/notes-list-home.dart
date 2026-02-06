import 'package:flutter/material.dart';
import 'package:notes_application/api_client.dart';
import 'package:notes_application/note-card.dart';
import 'package:notes_application/note-editor-app.dart';
import 'package:notes_application/note_item.dart';

class NotesListHome extends StatefulWidget {
  const NotesListHome({super.key});

  @override
  State<NotesListHome> createState() => _NotesListHomeState();
}

class _NotesListHomeState extends State<NotesListHome> {
  List<NoteItem> _allNotes = [];
  List<NoteItem> _filteredNotes = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNotes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        _filteredNotes = _allNotes;
        _isLoading = false;
      });
    } catch (e) {
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
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
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
    );
  }
}
