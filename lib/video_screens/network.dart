import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pod_player/pod_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:speech_to_text/buttons_bar.dart';
import 'package:speech_to_text/text_editor.dart';

class PlayVideoFromLocalMedia extends StatefulWidget {
  const PlayVideoFromLocalMedia({Key? key, required this.filePath, required this.globalColor}) : super(key: key);

  final File filePath;
  final Color globalColor;
  // static const routeName = '/youtube-screen';
  @override
  State<PlayVideoFromLocalMedia> createState() => _PlayVideoFromLocalMediaState();
}

class _PlayVideoFromLocalMediaState extends State<PlayVideoFromLocalMedia> {
  late final PodPlayerController controller;
  final videoTextFieldCtr = TextEditingController();
  final screenshot_Controller = ScreenshotController();
  final TextEditingController noteController = TextEditingController();
  GlobalKey previewContainer = new GlobalKey();

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [

      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print('$info');
  }

  @override
  void initState() {
    _requestPermission();
    controller = PodPlayerController(playVideoFrom: PlayVideoFrom.file(widget.filePath))
      ..initialise();
    // loadVideo()
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Media')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Screenshot(
                controller: screenshot_Controller,
                child: Container(
                  padding: EdgeInsetsDirectional.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: PodVideoPlayer(
                    controller: controller,
                    videoThumbnail: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dW5zcGxhc2h8ZW58MHx8MHx8&w=1000&q=80',
                      ),
                      //fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),



                    Row(children: [
                      Expanded(
                        flex:3,
                    child: TextField(

                        decoration: const InputDecoration(

                          labelText: 'Enter Title',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          hintText: 'https://youtu.be/A3ltMaM6noM',
                          border: OutlineInputBorder(),
                        ),
                      ),),

                      Expanded(
                        flex:1,
                        child: Container(

                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Progress(
                          noteController: noteController,
                          previewContainer: previewContainer,
                          screenshotController: screenshot_Controller,
                          controller: controller,
                          filePath: widget.filePath.toString(),
                        ),
                      ),)

                  ],
                ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: TextEditor(
                  controller: controller,
                  noteController: noteController,
                ),
              ),
              //const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}











// import 'package:pod_player/pod_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';

// class PlayVideoFromNetwork extends StatefulWidget {
//   const PlayVideoFromNetwork({Key? key}) : super(key: key);

//   @override
//   State<PlayVideoFromNetwork> createState() => _PlayVideoFromNetworkState();
// }

// class _PlayVideoFromNetworkState extends State<PlayVideoFromNetwork> {
//   late final PodPlayerController controller;
//   final videoTextFieldCtr = TextEditingController();

//   @override
//   void initState() {
//     controller = PodPlayerController(
//       playVideoFrom: PlayVideoFrom.file(file),   
//     )..initialise();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Play video from Netwok')),
//       body: SafeArea(
//         child: Center(
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//               PodVideoPlayer(
//                 controller: controller,
//                 podProgressBarConfig: const PodProgressBarConfig(
//                   padding: kIsWeb
//                       ? EdgeInsets.zero
//                       : EdgeInsets.only(
//                           bottom: 20,
//                           left: 20,
//                           right: 20,
//                         ),
//                   playingBarColor: Colors.blue,
//                   circleHandlerColor: Colors.blue,
//                   backgroundColor: Colors.blueGrey,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               _loadVideoFromUrl()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Row _loadVideoFromUrl() {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: TextField(
//             controller: videoTextFieldCtr,
//             decoration: const InputDecoration(
//               labelText: 'Enter video url',
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               hintText:
//                   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         FocusScope(
//           canRequestFocus: false,
//           child: ElevatedButton(
//             onPressed: () async {
//               if (videoTextFieldCtr.text.isEmpty) {
//                 snackBar('Please enter the url');
//                 return;
//               }
//               try {
//                 snackBar('Loading....');
//                 FocusScope.of(context).unfocus();
//                 await controller.changeVideo(
//                   playVideoFrom: PlayVideoFrom.network(videoTextFieldCtr.text),
//                 );
//                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
//               } catch (e) {
//                 snackBar('Unable to load,\n $e');
//               }
//             },
//             child: const Text('Load Video'),
//           ),
//         ),
//       ],
//     );
//   }

//   void snackBar(String text) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(text),
//         ),
//       );
//   }
// }
