import 'package:flutter/material.dart';
import 'package:peplocker/utils/utils.dart';
import 'package:peplocker/widgets/pep_raised_button.dart';

class DeleteNote extends StatelessWidget {
  final Function() onDelete;
  const DeleteNote({Key key, this.onDelete}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 15.0),
        child: IconButton(
          icon: Icon(Icons.delete_outline_rounded),
          onPressed: () {
            Utils.showDetailedDialog(
                AlertLevel.WARNING,
                'Confirm',
                'Are you sure you want to permanently delete this note?',
                false,
                context, [
              PepRaisedButton(
                  text: 'Yes, delete', onPressed: onDelete, isLoading: false),
              Utils.getFlatButton('Dismiss', () {
                Navigator.of(context).pop();
              })
            ]);
          },
        ));
  }
}
