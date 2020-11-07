import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peplocker/model/note.dart';
import 'package:peplocker/screens/change_password.dart';
import 'package:peplocker/screens/edit_note.dart';
import 'package:peplocker/screens/login.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/app_lifecycle_aware_state.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:peplocker/utils/drive_client.dart';
import 'package:peplocker/utils/notes_repository.dart';
import 'package:peplocker/utils/utils.dart';
import 'package:peplocker/widgets/custom_search.dart';
import 'package:peplocker/widgets/note_card.dart';

class ListNotes extends StatefulWidget {
  final DriveClient driveClient;
  const ListNotes({Key key, this.driveClient}) : super(key: key);
  @override
  ListNotesState createState() => ListNotesState();
}

class ListNotesState extends AppLifecycleAwareState<ListNotes> {
  List<Note> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNotesFromRepo();
  }

  void loadNotesFromRepo() async {
    setState(() {
      this.notes = NotesRepositoryFactory.getRepository().getNotes();
    });
  }

  Future<void> saveNote(Note note) async {
    setState(() {
      this.isLoading = true;
    });
    try {
      await NotesRepositoryFactory.getRepository().saveNote(note);
      setState(() {
        this.isLoading = false;
        this.notes = NotesRepositoryFactory.getRepository().getNotes();
      });
    } catch (err) {
      Utils.toast('Note could not be saved, something went wrong');
      setState(() {
        this.isLoading = false;
      });
      return;
    }
  }

  Future<void> deleteNote(Note note) async {
    setState(() {
      this.isLoading = true;
    });
    try {
      await NotesRepositoryFactory.getRepository().deleteNote(note);
      setState(() {
        this.isLoading = false;
        this.notes = NotesRepositoryFactory.getRepository().getNotes();
      });
    } catch (err) {
      Utils.toast('Note could not be deleted, something went wrong');
      setState(() {
        this.isLoading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.white),
      appBar: AppBar(
        title: Text('My Notes'),
        backgroundColor: Color(AppColors.primaryColor),
        actions: [
          IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () async {
                var searchedNote = await showSearch<Note>(
                  context: context,
                  delegate: CustomSearch(hintText: 'Search Notes'),
                );
                if (searchedNote != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditNote(
                            note: searchedNote,
                            update: saveNote,
                            delete: deleteNote)),
                  );
                }
              }),
          PopupMenuButton(
            itemBuilder: (_) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  child: new Text('Change password'),
                  value: Constants.changePassword),
              new PopupMenuItem<String>(
                  child: new Text('Sign out of Google Drive'),
                  value: Constants.signOut),
            ],
            onSelected: (String val) {
              if (val == Constants.signOut) {
                widget.driveClient.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              } else if (val == Constants.changePassword) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        child: isLoading
            ? Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.5),
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(AppColors.primaryColor)),
                ))
            : (this.notes.length == 0
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(image: AssetImage('assets/images/notes.png')),
                        Container(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(
                              '''you haven\'t added any notes yet
tap the + button below to add one''',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w100),
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ))
                : SingleChildScrollView(
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      child: Column(children: getNotes()),
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditNote(update: saveNote, delete: deleteNote)),
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
                          delete: deleteNote,
                        )),
              );
            },
          ))
        });
    return noteCards;
  }
}
