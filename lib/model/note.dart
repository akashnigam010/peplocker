class Note {
  int id;
  String title;
  String content;
  DateTime lastUpdated;

  Note();

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        lastUpdated = DateTime.parse(json['lastUpdated']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'lastUpdated': lastUpdated.toIso8601String()
      };
}
