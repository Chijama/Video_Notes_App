import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Note extends ChangeNotifier {
  late String noteId;
  String noteTitle;
  String? noteContent;
  final Color fldNoteColor;
  final String folderID;
  //NoteState state;
  final DateTime createdAt;
  DateTime? modifiedAt;
  String noteLink;

  /// Instantiates a [Note].
  Note(
      {required this.noteTitle,
      this.noteContent,
      required this.fldNoteColor,
      required this.folderID,
      required this.noteLink,
      //this.state,
      required this.createdAt,
      this.modifiedAt,
      this.noteId = "0"}) {
    // ID must be editable because the note object can be created from DB.
    if (this.noteId == "0") {
      // This means a new note is created.
      var uuid = Uuid();
      noteId = uuid.v4();
    }
  }
}
