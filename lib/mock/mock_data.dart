import 'package:peplocker/model/note.dart';

class MockData {
  static List<Note> getMockNotes() {
    List<Note> notes = [];
    Note n1 = new Note();
    n1.id = 1;
    n1.title = 'Note 1';
    n1.content = 'This is a samplessssss note';
    n1.lastUpdated = DateTime.now();
    notes.add(n1);
    
    Note n2 = new Note();
    n2.id = 2;
    n2.title = 'Note 2';
    n2.content = 'This is a sample note 2';
    n2.lastUpdated = DateTime.now();
    notes.add(n2);

    Note n3 = new Note();
    n3.id = 2;
    n3.title = 'Note 2';
    n3.content = 'This is a sample note 2';
    n3.lastUpdated = DateTime.now();
    notes.add(n3);

    Note n4 = new Note();
    n4.id = 2;
    n4.title = 'Note 2';
    n4.content = 'This is a sample note 2';
    n4.lastUpdated = DateTime.now();
    notes.add(n4);

    Note n5 = new Note();
    n5.id = 2;
    n5.title = 'Note 2';
    n5.content = 'This is a sample note 2';
    n5.lastUpdated = DateTime.now();
    notes.add(n5);

    Note n6 = new Note();
    n6.id = 2;
    n6.title = 'Note 2';
    n6.content = 'This is a sample note 2';
    n6.lastUpdated = DateTime.now();
    notes.add(n6);

    Note n7 = new Note();
    n7.id = 2;
    n7.title = 'Note 2';
    n7.content = 'This is a sample note 2';
    n7.lastUpdated = DateTime.now();
    notes.add(n7);

    Note n8 = new Note();
    n8.id = 2;
    n8.title = 'Note 2';
    n8.content = 'This is a sample note 2';
    n8.lastUpdated = DateTime.now();
    notes.add(n8);

    return notes;
  }
}