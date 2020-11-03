import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peplocker/model/note.dart';
import 'package:peplocker/screens/edit_note.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/drive_client.dart';
import 'package:peplocker/utils/notes_repository.dart';
import 'package:peplocker/widgets/note_card.dart';

class ListNotes extends StatefulWidget {
  final DriveClient driveClient;
  const ListNotes({Key key, this.driveClient}) : super(key: key);
  @override
  ListNotesState createState() => ListNotesState();
}

class ListNotesState extends State<ListNotes> {
  List<Note> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeRepository();
  }

  void initializeRepository() async {
    setState(() {
      this.isLoading = true;
    });
    if (widget.driveClient != null) {
      var notes = await widget.driveClient.readAllNotes();
      NotesRepositoryFactory.createRepository(widget.driveClient, notes);
      setState(() {
        this.isLoading = false;
        this.notes = notes;
      });
    }
  }

  void saveNote(Note note) {
    if (note != null) {
      setState(() {
        this.isLoading = true;
      });
      NotesRepositoryFactory.getRepository().saveNote(note);
      setState(() {
        this.isLoading = false;
        this.notes = NotesRepositoryFactory.getRepository().getNotes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PepNotes'),
        backgroundColor: Color(AppColors.primaryColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(children: getNotes()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditNote(update: saveNote)),
          );
        },
        tooltip: 'Add Note',
        child: Icon(
          Icons.add,
          color: Color(AppColors.black),
        ),
        backgroundColor: Color(AppColors.primaryColor),
      ),
    );
  }

  List<Widget> getNotes() {
    List<Widget> noteCards = [];
    notes?.forEach((note) => {
          noteCards.add(NoteCard(
            note: note,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditNote(
                          note: note,
                          update: saveNote,
                        )),
              );
            },
          ))
        });
    return noteCards;
  }
}
