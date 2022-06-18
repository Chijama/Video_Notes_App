import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class TextEditor extends StatefulWidget {
  const TextEditor({Key? key}) : super(key: key);

  @override
  State<TextEditor> createState() => _TextEditorState();
}

QuillController _controller = QuillController.basic();

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: QuillToolbar.basic(controller: _controller),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.lightBlueAccent,
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ]),
                  // child: Container(
                  //   child: TextField(
                  //     maxLines: 8, //or null
                  //     decoration: InputDecoration.collapsed(
                  //         hintText: "Enter your text here"),
                  //   ),
                  //),

                  child: QuillEditor.basic(
                      controller: _controller, readOnly: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
