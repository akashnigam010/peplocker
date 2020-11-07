import 'dart:collection';

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
  final Map<int, Note> _notesMap;
  DriveClient _driveClient;
  NotesRepository._(this._driveClient, this._notesMap);

  factory NotesRepository(DriveClient driveClient, List<Note> notes) {
    final Map<int, Note> notesMap = new HashMap();
    for (Note note in notes) {
      notesMap.update(note.id, (value) => note, ifAbsent: () => note);
    }
    return new NotesRepository._(driveClient, notesMap);
  }

  set driveClient(DriveClient driveClient) => this._driveClient = driveClient;

  Future<void> syncNotes() async {
    await _driveClient.writeNotes(this._notesMap.values.toList());
  }

  List<Note> getNotes() {
    List<Note> notes = this._notesMap.values.toList();
    notes.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    return notes;
  }

  Future<Note> saveNote(Note note) async {
    final now = DateTime.now();
    if (note.id == null) {
      note.id = now.millisecondsSinceEpoch;
    }
    note.lastUpdated = now;
    this._notesMap.update(note.id, (value) => note, ifAbsent: () => note);
    await syncNotes();
    return note;
  }

  Future<void> deleteNote(Note note) async {
    this._notesMap.remove(note.id);
    await syncNotes();
  }
}
