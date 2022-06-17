import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:permission_handler/permission_handler.dart';
import 'package:pod_player/pod_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:intl/intl.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

class Progress extends StatelessWidget {
  final PodPlayerController controller;
  final ScreenshotController screenshotController;

  //final List<Duration> timestamps;
  const Progress(
      {required this.controller, required this.screenshotController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(Icon(Icons.timer), 'Timestamps', getPosition()),
            buildButton(
              Icon(Icons.camera),
              'Screenshot',
              getScreenshot(),
            )
          ],
        ),
      );

  Widget buildButton(Widget icons, String tip, Future onpressed) => ClipRRect(
        //clipBehavior: Clip.hardEdge ,
        borderRadius: BorderRadius.circular(20),
        child: IconButton(
          tooltip: tip,
          icon: icons,
          onPressed: () => onpressed,
        ),
      );

  Future getScreenshot() async {
    final image = await screenshotController.capture();
    if (image == null) return;
    //await saveImage(image);
  }

  // Future<String> saveImage(Uint8List bytes) async {
  //   await [Permission.storage].request();
  //   final time = DateTime.now()
  //       .toIso8601String()
  //       .replaceAll('.', '_')
  //       .replaceAll(':', '_');
  //   final name = 'screenshot_$time';
  //   final result = await ImageGallerySaver.saveImage(bytes, name: name);
  //   return result['filePath'];
  // }

  Future getPosition() async {
    String currentPosition = controller.currentVideoPosition.toString();
  }

  Future goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final currentPosition = await controller.currentVideoPosition;
    final newPosition = builder(currentPosition);

    await controller.videoSeekTo(newPosition);
  }
}
