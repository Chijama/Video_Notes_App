import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewNote extends StatefulWidget {
  static const routeName = '/new-notes';
  //const NewNote({Key? key}) : super(key: key);
  final Function addNt;
  NewNote(this.addNt);

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final titlecontroller = TextEditingController();
  final linkcontroller = TextEditingController();

  void pickVideoType(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Offline',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void submitData() {
    final enteredTitle = titlecontroller.text;
    final enteredLink = linkcontroller.text;

    if (enteredTitle.isEmpty || enteredLink.isEmpty) {
      return;
    }

    widget.addNt(
      titlecontroller.text,
      linkcontroller.text,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // final routeArgs =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final String folderId = routeArgs['id'];
    // final String folderColor = routeArgs['color'];

    return Card(
      elevation: 5,
      child: Container(
        height: 300,
        width: 300,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titlecontroller,
              onSubmitted: (_) => submitData(),
              // onChanged: (value) {
              //   amountInput=value;
              // },
            ),
            if (pickVideoType == true)
              TextField(
                decoration: InputDecoration(labelText: 'Link'),
                controller: linkcontroller,
                onSubmitted: (_) => submitData(),
                // onChanged: (value) {
                //   amountInput=value;
                // },
              )
            else
              Text("Choose Video from Storage"),
            ElevatedButton(
              child: Text('Create Note'),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: submitData,
            )
          ],
        ),
      ),
    );
  }
}
