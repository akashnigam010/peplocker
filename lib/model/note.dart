import 'dart:collection';

class Note {
  int id;
  String title;
  String content;
  DateTime lastUpdated;

  /// See class [Color] in this package for sample object that can be added to this map
  /// 
  /// Additional attributes of the note.
  /// 
  /// It could have a unique string as key, and any object or literal as value. For example: 
  /// 
  /// note.attributes.update('color', (value) => new Color(123, 'blue'), ifAbsent: () => new Color(321, 'black'));
  /// 
  /// or
  /// 
  /// note.attributes.update('isArchive', (value) => false, ifAbsent: () => false);
  /// 
  /// And it could be retrieved as follows:
  /// 
  /// if (note.attributes.containsKey('color')) {
  /// 
  ///   print(note.attributes['color']);
  /// 
  /// }
  /// 
  /// if (note.attributes.containsKey('isArchive')) {
  /// 
  ///   print(note.attributes['isArchive']);
  /// 
  /// }
  Map<String, dynamic> attributes = new HashMap();

  Note();

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        lastUpdated = DateTime.parse(json['lastUpdated']),
        attributes =
            json['attributes'] == null ? new HashMap() : json['attributes'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'lastUpdated': lastUpdated.toIso8601String(),
        'attributes': attributes,
      };
}
