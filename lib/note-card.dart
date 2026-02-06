import 'package:flutter/material.dart';
import 'package:notes_application/note_item.dart';

class NoteCard extends StatelessWidget {
  final NoteItem note;
  final VoidCallback onTap;

  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Define your gold color to match the editor
    const goldColor = Color(0xFFFFB000);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
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
                  // Logic: Show filled gold star if favorite, else light gray/hidden
                  Icon(
                    note.favourite ? Icons.star : Icons.star_border,
                    color: note.favourite ? goldColor : Colors.transparent,
                    size: 18,
                  ),
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
