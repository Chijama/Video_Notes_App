//import 'package:final_year_project/widgets/new_note.dart';
import 'package:flutter/material.dart';
import '/screens/folder_notes_screen.dart';

class FolderItem extends StatelessWidget {
  final String id;
  final String title;
  final Color color;

  FolderItem(this.id, this.title, this.color);

  void selectFolder(BuildContext ctx) {
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: ((ctx) => FolderNotesScreen(
                noteId: id, folderTitle: title, globalColor: color))));
  }
  //   void selectNote(BuildContext ctx) {
  //   Navigator.of(ctx).pushNamed(
  //     NewNote.routeName,
  //     arguments: {
  //       'id': id,
  //       'color': color,
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectFolder(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
