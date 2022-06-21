import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pod_player/pod_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class Progress extends StatefulWidget {
  final PodPlayerController controller;
  final ScreenshotController screenshotController;
  final String filePath;
  final TextEditingController noteController;
  final GlobalKey previewContainer;

  //final List<Duration> timestamps;
  const Progress(
      {required this.controller,
      required this.screenshotController,
      required this.filePath,
      required this.noteController,
      required this.previewContainer,
      Key? key})
      : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(const Icon(Icons.timer), 'Timestamps', getPosition),
        const SizedBox(width: 30),
        buildButton(const Icon(Icons.camera), 'Screenshot', getScreenshot2),
        const SizedBox(width: 30),
        buildButton(const Icon(Icons.notes_outlined), 'Transcripts', loadTranscript),
        const SizedBox(width: 30),
        buildButton(const Icon(Icons.camera), 'Real-Time Transcripts', getPosition)
      ],
    );
  }

  Widget buildButton(Widget icons, String tip, Function()? onpressed) {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: IconButton(
        onPressed: getPosition,
        icon: icons,
        color: Colors.white,
      ),
    );
  }

  Future getScreenshot() async {
    final image = await widget.screenshotController.capture();
    if (image == null) return;
    final result = await ImageGallerySaver.saveImage(image.buffer.asUint8List());
    print('$image ********** Saved to gallery *********** $result');
    _showInSnackBar(message: 'Saved to gallery - video screenshot');
    //await saveImage(image);
  }

  Future getScreenshot2() async {
    List<String> imagePaths = [];
    final RenderBox box = context.findRenderObject() as RenderBox;
    return new Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary =
          widget.previewContainer.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/screenshot.png');

      print(directory);
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {
        await Share.shareFiles(imagePaths,
            subject: 'Share',
            text: 'Check this Out!',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }).catchError((onError) {
        print(onError);
      });
    });
  }

  loadTranscript() async {
    print(widget.filePath);
    final url = 'http://127.0.0.1:5000/name';
    return await http.post(Uri.parse(url), body: json.encode({'name': widget.filePath}));
  }

  void _showInSnackBar({String message = ''}) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        duration: (const Duration(seconds: 3)),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
    );
  }

  // Future<String> saveImage(Uint8List bytes) async {
  getPosition() async {
    String currentPosition = widget.controller.currentVideoPosition.toString();
    setState(() {
      widget.noteController.text = widget.noteController.text +
          " " +
          "${widget.controller.currentVideoPosition.toString().replaceRange(0, 1, "").replaceRange(7, 13, "").replaceFirst(":", "").replaceAll(".", "")}";
    });
    log(currentPosition);
    return currentPosition;
  }
}

Future goToPosition(
  Duration Function(Duration currentPosition) builder,
) async {
  //final currentPosition = controller.currentVideoPosition;
  //final newPosition = builder(currentPosition);

  // await widget.controller.videoSeekTo(newPosition);
}
