import 'package:flutter/material.dart';
import 'package:peplocker/model/note.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/utils.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function onTap;
  const NoteCard({Key key, this.note, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Color(AppColors.lightGrey)),
                color: Color(AppColors.white),
                boxShadow: [
                  BoxShadow(
                    color: Color(AppColors.lightGrey),
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 5.0,
                  ),
                ],),
            child: Column(
              children: [
                note.title.isNotEmpty
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          Utils.titlePreview(note.title),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(AppColors.greyBlack),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800),
                        ),
                      )
                    : Container(),
                note.content.isNotEmpty
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          Utils.contentPreview(note.content),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(AppColors.greyBlack),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    Utils.formatDateTime(note.lastUpdated),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Color(AppColors.darkGrey),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
