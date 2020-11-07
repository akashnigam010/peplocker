import 'package:flutter/material.dart';
import 'package:peplocker/model/note.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/notes_repository.dart';
import 'package:peplocker/widgets/note_card.dart';

class CustomSearch extends SearchDelegate<Note> {
  List<Note> data = NotesRepositoryFactory.getRepository().getNotes();

  CustomSearch({
    String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: Icon(
              Icons.clear,
              color: Color(AppColors.greyBlack),
            ),
            onPressed: () => query = '')
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.arrow_back, color: Color(AppColors.greyBlack)),
      onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Note> listToShow;
    if (query.isNotEmpty) {
      listToShow = data.where((note) {
        return note.title.contains(query) || note.content.contains(query);
      }).toList();
    } else {
      listToShow = [];
    }

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        itemCount: listToShow.length,
        itemBuilder: (_, i) {
          var note = listToShow[i];
          return ListTile(
            title: NoteCard(
              note: note,
              onTap: () => close(context, note),
            ),
            onTap: () => close(context, note),
          );
        },
      ),
    );
  }
}
