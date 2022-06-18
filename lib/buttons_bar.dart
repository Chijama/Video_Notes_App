
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pod_player/pod_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Progress extends StatefulWidget {
  final PodPlayerController controller;
  final ScreenshotController screenshotController;
  final String filePath;

  //final List<Duration> timestamps;
  const Progress(
      {required this.controller, required this.screenshotController,  required this.filePath, Key? key})
      : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  var _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(Icon(Icons.timer), 'Timestamps', getPosition()),
            SizedBox(width: 30),
            buildButton(Icon(Icons.camera), 'Screenshot', getPosition()),
            SizedBox(width: 30),
            buildButton(
                Icon(Icons.notes_outlined), 'Transcripts', loadTranscript()),
            SizedBox(width: 30),
            buildButton(
                Icon(Icons.camera), 'Real-Time Transcripts', getPosition())
          ],
        ),
      );

  Widget buildButton(Widget icons, String tip, Future onpressed) => ClipRRect(
        //clipBehavior: Clip.hardEdge ,

        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40.0,
          width: 40.0,
          color: Colors.blue,
          child: IconButton(
            color: Colors.white,
            tooltip: tip,
            icon: icons,
            onPressed: () => onpressed,
          ),
        ),
      );

  Future getScreenshot() async {
    final image = await widget.screenshotController.capture();
    if (image == null) return;
    final result =
        await ImageGallerySaver.saveImage(image.buffer.asUint8List());
    print('$image ********** Saved to gallery *********** $result');
    _showInSnackBar(message: 'Saved to gallery - video screenshot');
    //await saveImage(image);
  }
  Future loadTranscript() async{
    print(widget.filePath);
    final url = 'http://127.0.0.1:5000/name';
    return await http.post(Uri.parse(url), body: json.encode({'name': widget.filePath}));

  }
  void _showInSnackBar({String message = ''}) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        duration: (Duration(seconds: 3)),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
    );
  }
}


// Future<String> saveImage(Uint8List bytes) async {
Future getPosition() async {
  //String currentPosition = widget.controller.currentVideoPosition.toString();
}

Future goToPosition(
  Duration Function(Duration currentPosition) builder,
) async {
  //final currentPosition = controller.currentVideoPosition;
  //final newPosition = builder(currentPosition);

  // await widget.controller.videoSeekTo(newPosition);
}
