import 'package:pod_player/pod_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:speech_to_text/buttons_bar.dart';
import 'package:speech_to_text/text_editor.dart';
import 'package:flutter/material.dart';

class PlayVideoFromYoutube extends StatefulWidget {
  const PlayVideoFromYoutube({Key? key, required this.youtubeVideoUrl})
      : super(key: key);

  final String youtubeVideoUrl;
  // static const routeName = '/youtube-screen';
  @override
  State<PlayVideoFromYoutube> createState() => _PlayVideoFromYoutubeState();
}

class _PlayVideoFromYoutubeState extends State<PlayVideoFromYoutube> {
  late final PodPlayerController controller;
  final videoTextFieldCtr = TextEditingController();
  final screenshotController = ScreenshotController();

  void loadVideo() async {
    await controller.changeVideo(
        playVideoFrom: PlayVideoFrom.youtube(widget.youtubeVideoUrl));
  }

  @override
  void initState() {
    controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube(widget.youtubeVideoUrl))
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
      appBar: AppBar(title: const Text('Youtube player')),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                  child: PodVideoPlayer(
                    frameAspectRatio: 16 / 9,
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
              Expanded(
                child: Progress(
                  screenshotController: screenshotController,
                  controller: controller,
                ),
                flex: 1,
              ),
              Expanded(
                flex: 3,
                child: TextEditor(),
              ),
              //const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Row _loadVideoFromUrl() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: videoTextFieldCtr,
            decoration: const InputDecoration(
              labelText: 'Enter youtube url/id',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'https://youtu.be/A3ltMaM6noM',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        FocusScope(
          canRequestFocus: false,
          child: ElevatedButton(
            onPressed: () async {
              if (videoTextFieldCtr.text.isEmpty) {
                snackBar('Please enter the url');
                return;
              }
              try {
                snackBar('Loading....');
                FocusScope.of(context).unfocus();
                await controller.changeVideo(
                  playVideoFrom: PlayVideoFrom.youtube(videoTextFieldCtr.text),
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              } catch (e) {
                snackBar('Unable to load,\n $e');
              }
            },
            child: const Text('Load Video'),
          ),
        ),
      ],
    );
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
  }
}









// import 'package:pod_player/pod_player.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:speech_to_text/text_editor.dart';
// import 'package:flutter/material.dart';

// class PlayVideoFromYoutube extends StatefulWidget {
//   const PlayVideoFromYoutube({Key? key}) : super(key: key);

//   // static const routeName = '/youtube-screen';
//   @override
//   State<PlayVideoFromYoutube> createState() => _PlayVideoFromYoutubeState();
// }

// class _PlayVideoFromYoutubeState extends State<PlayVideoFromYoutube> {
//   late final PodPlayerController controller;

//   final screenshot_controller = ScreenshotController();

//   @override
//   void initState() {
//     controller = PodPlayerController(
//       playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/A3ltMaM6noM'),
//     )
//       ..addListener(() => setState(() {}))
//       ..initialise();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final routarg = ModalRoute.of(context)!.settings.arguments
//     //     as Map<String, TextEditingController>;
//     // final videoTextFieldCtr = routarg['link'];
//     return Scaffold(
//       appBar: AppBar(title: const Text('Youtube player')),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               Screenshot(
//                 controller: screenshot_controller,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height / 2,
//                   child: PodVideoPlayer(
//                     controller: controller,
//                     videoThumbnail: const DecorationImage(
//                       image: NetworkImage(
//                         'https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dW5zcGxhc2h8ZW58MHx8MHx8&w=1000&q=80',
//                       ),
//                       //fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(flex: 1, child: ButtonBar()),
//               Expanded(
//                 flex: 3,
//                 child: TextEditor(),
//               ),
//               //const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Row _loadVideoFromUrl() {
//   //   return Row(
//   //     children: [
//   //       Expanded(
//   //         flex: 2,
//   //         child: TextField(
//   //           controller: videoTextFieldCtr,
//   //           decoration: const InputDecoration(
//   //             labelText: 'Enter youtube url/id',
//   //             floatingLabelBehavior: FloatingLabelBehavior.always,
//   //             hintText: 'https://youtu.be/A3ltMaM6noM',
//   //             border: OutlineInputBorder(),
//   //           ),'
//   //         ),
//   //       ),
//   //       const SizedBox(width: 10),
//   //       FocusScope(
//   //         canRequestFocus: false,
//   //         child: ElevatedButton(
//   //           onPressed: () async {
//   //             if (videoTextFieldCtr.text.isEmpty) {
//   //               snackBar('Please enter the url');
//   //               return;
//   //             }
//   //             try {
//   //               snackBar('Loading....');
//   //               FocusScope.of(context).unfocus();
//   //               await controller.changeVideo(
//   //                 playVideoFrom: PlayVideoFrom.youtube(videoTextFieldCtr.text),
//   //               );
//   //               ScaffoldMessenger.of(context).hideCurrentSnackBar();
//   //             } catch (e) {
//   //               snackBar('Unable to load,\n $e');
//   //             }
//   //           },
//   //           child: const Text('Load Video'),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // void snackBar(String text) {
//   //   ScaffoldMessenger.of(context)
//   //     ..hideCurrentSnackBar()
//   //     ..showSnackBar(
//   //       SnackBar(
//   //         content: Text(text),
//   //       ),
//   //     );
// }
