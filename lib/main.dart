import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peplocker/mock/mock_data.dart';
import 'package:peplocker/model/note.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/drive_client.dart';
import 'package:peplocker/widgets/note_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(AppColors.primaryColor)));
    return MaterialApp(
      title: 'Peplock',
      theme: ThemeData(
        primaryColor: Color(AppColors.primaryColor),
        scaffoldBackgroundColor: Color(AppColors.white),
      ),
      home: MyHomePage(title: 'Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> notes = [];
  final driveClient = DriveClient();

  @override
  void initState() {
    super.initState();
    notes = MockData.getMockNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(AppColors.primaryColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          // child: Column(children: getNotes()),
          child: MaterialButton(
            onPressed: () {
              driveClient.writeNotes(this.notes);
            },
            child: Text('Write Notes'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // driveClient.writeNotes(this.notes);
          driveClient.readAllNotes();
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
          ))
        });
    return noteCards;
  }
}
