import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:speech_to_text/buttons_bar.dart';
import 'package:speech_to_text/text_editor.dart';

class PlayVideoFromVimeo extends StatefulWidget {
  const PlayVideoFromVimeo({Key? key, required this.vimeoVideoId}) : super(key: key);
  final String vimeoVideoId;
  @override
  State<PlayVideoFromVimeo> createState() => _PlayVideoFromVimeoState();
}

class _PlayVideoFromVimeoState extends State<PlayVideoFromVimeo> {
  late final PodPlayerController controller;
  final videoTextFieldCtr = TextEditingController();
  final screenshot_controller = ScreenshotController();
  final TextEditingController noteController = TextEditingController();
  GlobalKey previewContainer = new GlobalKey();

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.vimeo('518228118'),
    )..initialise();
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
      appBar: AppBar(title: const Text('Vimeo player')),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Screenshot(
                controller: screenshot_controller,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
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
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Progress(
                        previewContainer: previewContainer,
                        screenshotController: screenshot_controller,
                        controller: controller,
                        noteController: noteController,
                        filePath: "",
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
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
