import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notes_application/services/api_client.dart';
import 'package:notes_application/models/note_item.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteItem? note; // If null, we are creating a new note
  final Function()? onNoteUpdated; // Callback when note is updated

  const NoteEditorScreen({super.key, this.note, this.onNoteUpdated});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSaving = false;
  late bool _isFavourite;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing note data or empty strings
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(
      text: widget.note?.content ?? "",
    );
    _isFavourite = widget.note?.favourite ?? false;

    debugPrint(
      "Initial favorite state: $_isFavourite for note: ${widget.note?.id}",
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // --- BACKEND INTEGRATION: SAVE LOGIC ---
  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Title cannot be empty")));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final data = {
        "title": _titleController.text,
        "body": _contentController.text,
        "favourite": _isFavourite,
      };

      debugPrint("=== SAVING NOTE ===");
      debugPrint("Note ID: ${widget.note?.id}");
      debugPrint("Favorite status: $_isFavourite");
      debugPrint("Data: $data");

      dynamic response;

      if (widget.note == null) {
        // CREATE NEW NOTE
        response = await ApiClient.dio.post("/notes", data: data);
      } else {
        // UPDATE EXISTING NOTE
        response = await ApiClient.dio.put(
          "/notes/${widget.note!.id}",
          data: data,
        );
      }

      debugPrint("=== RESPONSE ===");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Data: ${response.data}");

      // Check if response contains the updated favorite status
      if (response.data != null && response.data is Map) {
        final updatedNote = response.data as Map<String, dynamic>;
        if (updatedNote.containsKey('favourite')) {
          debugPrint(
            "Updated favorite in response: ${updatedNote['favourite']}",
          );
        }
      }

      if (mounted) {
        // Notify parent about the update
        if (widget.onNoteUpdated != null) {
          widget.onNoteUpdated!();
        }

        // Pass back the updated favorite status
        Navigator.pop(context, _isFavourite);
      }
    } catch (e) {
      debugPrint("Save error: $e");
      if (e is DioException) {
        debugPrint("Dio error response: ${e.response?.data}");
      }
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save note")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- BACKEND INTEGRATION: DELETE LOGIC ---
  Future<void> _deleteNote() async {
    if (widget.note == null) return;

    // Show confirmation dialog first
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // User cancelled
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // User confirmed
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If the user clicked "Delete" (true), proceed with the API call
    if (confirm == true) {
      try {
        await ApiClient.dio.delete("/notes/${widget.note!.id}");
        if (mounted) {
          if (widget.onNoteUpdated != null) {
            widget.onNoteUpdated!();
          }
          Navigator.pop(context); // Go back to dashboard
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to delete note")),
          );
        }
      }
    }
  }

  // Toggle favorite function
  void _toggleFavorite() {
    setState(() {
      _isFavourite = !_isFavourite;
      debugPrint("Toggled favorite to: $_isFavourite");

      // Auto-save when toggling favorite? (Optional)
      // _saveNote();
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF6F7F8);
    const primaryBlue = Color(0xFF137FEC);
    const starColor = Color(0xFFE96A25);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Note', style: TextStyle(color: Colors.black)),
        actions: [
          // Star/Favorite button with visual feedback
          Tooltip(
            message: _isFavourite
                ? 'Remove from favorites'
                : 'Add to favorites',
            child: IconButton(
              icon: Icon(
                _isFavourite ? Icons.star : Icons.star_border,
                color: _isFavourite ? starColor : Colors.grey,
                size: 28,
              ),
              onPressed: _toggleFavorite,
            ),
          ),
          if (widget.note != null)
            Tooltip(
              message: 'Delete note',
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.black),
                onPressed: _deleteNote,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Title Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
          ),
          // Content Input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 18, height: 1.5),
                decoration: const InputDecoration(
                  hintText: "Start writing...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
            ),
          ),
          // Debug info (remove in production)
          // if (kDebugMode)
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       'Favorite: $_isFavourite',
          //       style: const TextStyle(color: Colors.red),
          //     ),
          //   ),
          // Footer meta-text
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Text(
              widget.note != null
                  ? "Last edited: ${widget.note!.date.split('T')[0]}"
                  : "New Note",
              style: const TextStyle(color: Color(0xFF4C739A), fontSize: 14),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'unique',
        onPressed: _isSaving ? null : _saveNote,
        backgroundColor: primaryBlue,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.check, color: Colors.white),
        label: const Text(
          "Save",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
