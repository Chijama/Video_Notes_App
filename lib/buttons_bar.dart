import 'dart:convert';
import 'dart:core';
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
import 'package:speech_to_text/video_screens/domain/controllers/youtube_controller.dart';

class Progress extends StatefulWidget {
  final PodPlayerController controller;
  final ScreenshotController screenshotController;
  final String filePath;
  final TextEditingController noteController;
  final GlobalKey previewContainer;
  final YoutubeProvider youtubeProvider;

  const Progress({
    Key? key,
    required this.controller,
    required this.screenshotController,
    required this.filePath,
    required this.noteController,
    required this.previewContainer,
    required this.youtubeProvider,
  }) : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int transcriptMinutePosition = 00;
  int transcriptSecondPosition = 00;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(const Icon(Icons.timer), 'Timestamps', getPosition),
        const SizedBox(width: 10),
        buildButton(const Icon(Icons.camera), 'Screenshot', getScreenshot2),
        const SizedBox(width: 10),
        buildButton(const Icon(Icons.notes_outlined), 'Transcripts', rewindToPosition),
        const SizedBox(width: 10),
        buildButton(const Icon(Icons.edit_note_sharp), 'Real-Time Transcripts', loadTranscript)
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
        onPressed: onpressed,
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
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary =
          widget.previewContainer.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = File('$directory/screenshot.png');

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
    // print(widget.filePath.split('/')[-1]);
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

  Future rewindToPosition() async {
    Duration rewind(Duration currentPosition) =>
        Duration(minutes: transcriptMinutePosition, seconds: transcriptSecondPosition);
    await goToPosition(rewind);
  }

  getPosition() async {
    // var prv = ref.watch(ytProviderController);

    String currentPosition = widget.controller.currentVideoPosition.toString();

    String shortCurrentPosition = widget.controller.currentVideoPosition
        .toString()
        .replaceRange(0, 1, "")
        .replaceRange(7, 13, "")
        .replaceFirst(":", "")
        .replaceAll(".", "");
    log(currentPosition);
    String minute = shortCurrentPosition.split(':')[0];
    String second = shortCurrentPosition.split(':')[1];
    log("minute ===> $minute");
    log("second ===>> $second");
    widget.youtubeProvider.taggedStamps.add(shortCurrentPosition);
    widget.youtubeProvider.taggedStamps = widget.youtubeProvider.taggedStamps;
    setState(() {
      transcriptMinutePosition = int.parse(minute);
      transcriptSecondPosition = int.parse(second);
      widget.noteController.text = widget.noteController.text + " " + shortCurrentPosition;
    });
    setState(() {});
    return currentPosition;
  }

  Future goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final currentPosition = widget.controller.currentVideoPosition;
    final newPosition = builder(currentPosition);
    await widget.controller.videoSeekTo(newPosition);
  }
}
