import 'package:peplocker/model/note.dart';
import 'package:peplocker/utils/drive_client.dart';

class NotesRepositoryFactory {
  static NotesRepository repository;

  static createRepository(DriveClient driveClient, List<Note> notes) {
    repository = new NotesRepository(driveClient, notes);
  }

  static NotesRepository getRepository() {
    if (repository == null) {
      throw new Error();
    }
    return repository;
  }
}

class NotesRepository {
  final DriveClient driveClient;
  final Map<int, Note> _notesMap;
  NotesRepository._(this.driveClient, this._notesMap);

  factory NotesRepository(DriveClient driveClient, List<Note> notes) {
    final Map<int, Note> notesMap = new Map();
    for (Note note in notes) {
      notesMap.update(note.id, (value) => note, ifAbsent: () => note);
    }
    return new NotesRepository._(driveClient, notesMap);
  }

  Future<void> syncNotes() async {
    await driveClient.writeNotes(this._notesMap.values.toList());
  }

  List<Note> getNotes() {
    List<Note> notes = this._notesMap.values.toList();
    notes.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    return notes;
  }

  Note saveNote(Note note) {
    final now = DateTime.now();
    if (note.id == null) {
      note.id = now.millisecondsSinceEpoch;
    }
    note.lastUpdated = now;
    this._notesMap.update(note.id, (value) => note, ifAbsent: () => note);
    syncNotes();
    return note;
  }
}
