import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Folder {
  late String id;
  final String title;
  final Color color;

  Folder({required this.title, this.color = Colors.orange, this.id = "0"}) {
    // ID must be editable because the note object can be created from DB.
    if (id == "0") {
      // This means a new note is created.
      var uuid = const Uuid();
      id = uuid.v1();
    }
  }
}
