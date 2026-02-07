import 'package:notes_application/services/api_client.dart';
import 'package:notes_application/models/note_item.dart';

class NotesController {
  // Waxaa laga soo aqriyaa dhammaan qoraallada (notes) backend-ka
  Future<List<NoteItem>> fetchNotes() async {
    try {
      final response = await ApiClient.dio.get("/notes");
      final List data = response.data;
      // Waxaan u bedeleynaa xogta ceeriin ah (JSON) liis ah NoteItem
      return data.map((n) => NoteItem.fromJson(n)).toList();
    } catch (e) {
      // Haddii uu qalad dhaco, soo celi liis eber ah si uusan app-ku u xirmin
      return [];
    }
  }

  // Shaqadan waxay kala shaandheysaa qoraallada iyadoo la eegayo raadinta ama favorites-ka
  List<NoteItem> filterNotes(
    List<NoteItem> notes,
    String query,
    bool showOnlyFavorites,
  ) {
    var filtered = notes;

    // Haddii la rabo kaliya kuwa 'Favorites' ah
    if (showOnlyFavorites) {
      filtered = filtered.where((note) => note.favourite == true).toList();
    }

    // Haddii uu jiro qoraal la raadinayo (Search)
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((note) {
        return note.title.toLowerCase().contains(lowerQuery) ||
            note.content.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    return filtered;
  }
}
