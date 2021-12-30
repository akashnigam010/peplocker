import 'package:flutter/material.dart';
import 'package:peplocker/model/note.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/app_lifecycle_aware_state.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:peplocker/utils/utils.dart';
import 'package:peplocker/widgets/delete_note.dart';
import 'package:peplocker/widgets/pep_raised_button.dart';

class EditNote extends StatefulWidget {
  final Note note;
  final Function(Note) update;
  final Function(Note) delete;
  final Function(Note) archive;
  const EditNote({Key key, this.note, this.update, this.delete, this.archive})
      : super(key: key);
  @override
  EditNoteState createState() => EditNoteState();
}

class EditNoteState extends AppLifecycleAwareState<EditNote> {
  String title = '';
  String content = '';
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool isLoading = false;

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

  void showLoader(bool flag) {
    setState(() {
      this.isLoading = flag;
    });
  }

  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    return isNoteUpdated()
        ? (Utils.showDetailedDialog(AlertLevel.WARNING, 'Confirm',
            Constants.discardNote, false, context, [
            PepRaisedButton(
                text: 'Yes',
                onPressed: () {
                  updateNote();
                  Navigator.pop(context);
                },
                isLoading: false),
            Utils.getFlatButton('No', () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            })
          ]))
        : true;
  }

  bool isNoteUpdated() {
    Note note = widget.note;
    if (note == null) {
      if (titleController.text.isNotEmpty ||
          contentController.text.isNotEmpty) {
        return true;
      }
    } else {
      if (note.title != titleController.text ||
          note.content != contentController.text) {
        return true;
      }
    }
    return false;
  }

  Future<void> updateNote() async {
    Note note = widget.note;
    if (note == null) {
      note = new Note();
    }
    note.title = titleController.text;
    note.content = contentController.text;
    widget.update(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              widget.note != null
                  ? DeleteNote(onDelete: () {
                      widget.delete(widget.note);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    })
                  : Container(),
            ],
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
                            fontWeight: FontWeight.bold,
                          )),
                      maxLines: 1,
                      onChanged: (value) {
                        setState(() {
                          this.title = value;
                        });
                      },
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.greyBlack),
                      ),
                      controller: titleController,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                  ),
                  Container(
                    height: (height - 170),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      color: Color(AppColors.white),
                    ),
                    child: TextField(
                      autofocus: widget.note == null ? true : false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                          hintText: 'Note',
                          hintStyle: TextStyle(
                              color: Color(AppColors.lightGrey),
                              fontSize: 16.0)),
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
                        fontWeight: FontWeight.bold,
                      ),
                      controller: contentController,
                    ),
                  ),
                  (widget.note != null)
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Last Edited ' +
                                Utils.formatDateTime(widget.note.lastUpdated),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Color(AppColors.darkGrey),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              isNoteUpdated() ? updateNote() : Navigator.pop(context);
            },
            tooltip: 'Save',
            child: Icon(
              Icons.check,
              color: Color(AppColors.black),
            ),
            backgroundColor: Color(AppColors.primaryColor),
          ),
        ));
  }
}
