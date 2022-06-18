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

class Progress extends StatefulWidget {
  final PodPlayerController controller;
  final ScreenshotController screenshotController;

  //final List<Duration> timestamps;
  const Progress(
      {required this.controller, required this.screenshotController, Key? key})
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
            buildButton(Icon(Icons.camera), 'Screenshot', getScreenshot()),
            SizedBox(width: 30),
            buildButton(
                Icon(Icons.notes_outlined), 'Screenshot', getScreenshot()),
            SizedBox(width: 30),
            buildButton(Icon(Icons.camera), 'Screenshot', getScreenshot())
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

_requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();
  final info = statuses[Permission.storage].toString();
  print('$info');
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
