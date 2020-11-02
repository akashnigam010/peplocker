import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peplocker/model/note.dart';
import 'package:peplocker/screens/notes_screen.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/utils.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteScreen(
                      note: note,
                    )),
          );
        },
        child: Container(
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Color(AppColors.lightGrey)),
              color: Color(AppColors.white),
              boxShadow: [
                BoxShadow(
                  color: Color(AppColors.lightGrey),
                  blurRadius: 1.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 1.0),
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        note.title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(AppColors.black),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        Utils.formatDateTime(note.lastUpdated),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color(AppColors.greyBlack),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    Utils.contentPreview(note.content),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(AppColors.greyBlack),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
