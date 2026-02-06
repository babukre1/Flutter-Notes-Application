class NoteItem {
  final String id;
  final String title;
  final String content;
  final String date;

  NoteItem({required this.id, required this.title, required this.content, required this.date});

  // Factory to convert JSON from Backend to a Dart Object
  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id'],
      title: json['title'] ?? "",
      content: json['body'] ?? "", // Backend uses 'body'
      date: json['updated_at'] ?? json['created_at'] ?? "",
    );
  }
}