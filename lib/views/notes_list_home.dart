import 'package:flutter/material.dart';
import 'package:notes_application/controllers/notes_controller.dart';
import 'package:notes_application/views/note_card.dart';
import 'package:notes_application/views/note_editor_app.dart';
import 'package:notes_application/models/note_item.dart';

class NotesListHome extends StatefulWidget {
  final bool showOnlyFavorites;
  const NotesListHome({super.key, this.showOnlyFavorites = false});

  @override
  State<NotesListHome> createState() => _NotesListHomeState();
}

class _NotesListHomeState extends State<NotesListHome>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<NoteItem> _allNotes = [];
  List<NoteItem> _filteredNotes = [];
  bool _isLoading = true;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();
  late final NotesController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = NotesController();
    // Delay the initial fetch to avoid blocking UI thread
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotes();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (!mounted) return;
    _filterNotes();
  }

  void _filterNotes() {
    setState(() {
      _filteredNotes = _notesController.filterNotes(
        _allNotes,
        _searchController.text,
        widget.showOnlyFavorites,
      );
    });
  }

  Future<void> _fetchNotes() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final notes = await _notesController.fetchNotes();
      if (!mounted) return;

      setState(() {
        _allNotes = notes;
        _filteredNotes = _notesController.filterNotes(
          _allNotes,
          _searchController.text,
          widget.showOnlyFavorites,
        );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      debugPrint('Error fetching notes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  Text(
                    widget.showOnlyFavorites ? "Favorites" : "Notes",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
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
                      color: primaryColor,
                      child: _buildContent(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "homeFab_${widget.showOnlyFavorites}",
        onPressed: () => _onAddNotePressed(context),
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  Widget _buildContent() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              "Failed to load notes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: _fetchNotes, child: const Text("Try Again")),
          ],
        ),
      );
    }

    if (_filteredNotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.showOnlyFavorites
                  ? Icons.star_border
                  : Icons.note_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              widget.showOnlyFavorites
                  ? "No favorite notes yet"
                  : "No notes found",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        final note = _filteredNotes[index];
        return NoteCard(
          key: ValueKey('note_${note.id}'),
          note: note,
          onTap: () => _onNoteTapped(context, note),
        );
      },
    );
  }

  Future<void> _onNoteTapped(BuildContext context, NoteItem note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditorScreen(note: note)),
    );
    if (!mounted) return;
    await _fetchNotes();
  }

  Future<void> _onAddNotePressed(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteEditorScreen()),
    );
    if (!mounted) return;
    await _fetchNotes();
  }
}
