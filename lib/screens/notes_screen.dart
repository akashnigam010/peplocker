import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peplocker/model/note.dart';
import 'package:peplocker/utils/app_colors.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  const NoteScreen({Key key, this.note}) : super(key: key);
  @override
  NoteScreenState createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  String title = '';
  String content = '';
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      this.title = widget.note.title;
      this.titleController.text = this.title;
      this.content = widget.note.content;
      this.contentController.text = this.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Color(AppColors.lightGrey),
          // title: Text(widget.title),
          ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(
            children: [
              Container(
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Color(AppColors.lightGrey),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      )),
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      this.title = value;
                    });
                  },
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Color(AppColors.greyBlack),
                  ),
                  controller: titleController,
                ),
              ),
              Container(
                height: (height - 150),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: Color(AppColors.white),
                ),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: InputBorder.none,
                      hintText: 'Note',
                      hintStyle: TextStyle(
                          color: Color(AppColors.lightGrey), fontSize: 16.0)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      this.content = value;
                    });
                  },
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(AppColors.greyBlack),
                  ),
                  controller: contentController,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Save',
        child: Icon(Icons.check, color: Color(AppColors.black),),
        backgroundColor: Color(AppColors.primaryColor),
      ),
    );
  }
}
