class Note {
  final int? id;
  final String subject;
  final String title;
  final String content;
  final String label;

  Note({this.id, required this.subject, required this.title, required this.content, required this.label});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'title': title,
      'content': content,
      'label': label,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      subject: map['subject'],
      title: map['title'],
      content: map['content'],
      label: map['label'],
    );
  }
}
