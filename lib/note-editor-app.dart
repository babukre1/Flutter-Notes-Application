import 'package:flutter/material.dart';
import 'package:notes_application/api_client.dart';
import 'package:notes_application/note_item.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteItem? note; // If null, we are creating a new note

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing note data or empty strings
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(
      text: widget.note?.content ?? "",
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
        "body": _contentController.text, // Backend uses 'body'
      };

      if (widget.note == null) {
        // CREATE NEW NOTE
        await ApiClient.dio.post("/notes", data: data);
      } else {
        // UPDATE EXISTING NOTE
        await ApiClient.dio.put("/notes/${widget.note!.id}", data: data);
      }

      if (mounted) {
        Navigator.pop(context); // Go back to dashboard after save
      }
    } catch (e) {
      debugPrint("Save error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save note")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- BACKEND INTEGRATION: DELETE LOGIC ---
  Future<void> _deleteNote() async {
    if (widget.note == null) return;

    try {
      await ApiClient.dio.delete("/notes/${widget.note!.id}");
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to delete note")));
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF6F7F8);
    const primaryBlue = Color(0xFF137FEC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.black),
            onPressed: () {},
          ),
          if (widget.note != null) // Only show delete if note exists
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black),
              onPressed: _deleteNote,
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
                maxLines: null, // Makes it behave like a textarea
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
      // Floating Action Button (Save)
      floatingActionButton: FloatingActionButton.extended(
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
