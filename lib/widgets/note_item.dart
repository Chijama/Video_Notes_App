import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  final String ntTitle;
  final String ntId;
  final Color ntColor;
  final DateTime created;
  NoteItem(this.ntTitle, this.ntColor, this.ntId, this.created);

  IconData note_sharp =
      IconData(0xeb43, fontFamily: 'MaterialIcons', matchTextDirection: true);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          note_sharp,
          color: ntColor,
          size: 100,
        ),
        Text(ntTitle),
        //Text(data)
      ],
    );
  }
}
