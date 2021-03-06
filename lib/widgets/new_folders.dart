import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewFolder extends StatefulWidget {
  final Function addFld;
  NewFolder(this.addFld);

  @override
  State<NewFolder> createState() => _NewFolderState();
}

class _NewFolderState extends State<NewFolder> {
  final titlecontroller = TextEditingController();

  Color colorInput = Color.fromRGBO(4, 56, 44, 1);

  Widget buildColorPicker() => ColorPicker(
        pickerColor: colorInput,
        enableAlpha: false,
        labelTypes: [],
        onColorChanged: (color) => setState(() {
          this.colorInput = color;
        }),
      );

  void pickColor(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Pick your color'),
          content: Column(
            children: [
              buildColorPicker(),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'SELECT',
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
    final enteredColor = colorInput;

    if (enteredTitle.isEmpty || enteredColor.value == null) {
      return;
    }

    widget.addFld(
      titlecontroller.text,
      colorInput,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: <Widget>[
          Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titlecontroller,
                onSubmitted: (_) => submitData(),
              ),
              Row(
                children: [
                  const Text('Color: '),
                  TextButton(
                    child: Text(
                      'SELECT COLOR',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: () => pickColor(context),
                    style: TextButton.styleFrom(
                      primary: Colors.blueAccent[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  child: const Text('Create Note'),
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.headline6,
                    primary: Colors.white,
                  ),
                  onPressed: submitData,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
