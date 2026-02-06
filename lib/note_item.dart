class NoteItem {
  final String id;
  final String title;
  final String content;
  final String date;
  final bool favourite; // Must be here!

  NoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.favourite,
  });

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id'].toString(),
      title: json['title'] ?? "",
      content: json['body'] ?? "", // Map 'body' from DB to 'content' in Flutter
      date: json['updated_at'] ?? "",
      // This is the critical line:
      favourite: json['favourite'] == 1 || json['favourite'] == true,
    );
  }
}
