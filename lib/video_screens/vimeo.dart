import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod_player/pod_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:speech_to_text/buttons_bar.dart';

import 'domain/controllers/youtube_controller.dart';

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
  List<String> taggedStamps = [];

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
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                Screenshot(
                  controller: screenshot_controller,
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
                const SizedBox(height: 30),

                Consumer(builder: (_, ref, __) {
                  return SizedBox(
                    child: Column(
                      children: [
                        Progress(
                          youtubeProvider: ref.watch(ytProviderController),
                          previewContainer: previewContainer,
                          screenshotController: screenshot_controller,
                          controller: controller,
                          noteController: noteController,
                          filePath: "",
                        ),
                        const SizedBox(height: 20),
                        // ignore: sized_box_for_whitespace
                        Container(
                          height: 400,
                          child: SingleChildScrollView(
                            child: Consumer(builder: (_, ref, __) {
                              var prv = ref.watch(ytProviderController);
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Builder(builder: (context) {
                                    if (prv.taggedStamps.isEmpty) return Text("No stamp yet");

                                    return Column(
                                      children: [
                                        ...List.generate(prv.taggedStamps.length, (index) {
                                          prv.controllers = List.generate(prv.taggedStamps.length,
                                              (i) => TextEditingController());
                                          return Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  rewindToPosition(prv.taggedStamps[index]);
                                                },
                                                child: Text(
                                                  prv.taggedStamps[index],
                                                  style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.white,
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.lightBlueAccent,
                                                            offset: Offset(1.0, 1.5),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 0.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextFormField(
                                                        controller: prv.controllers[index],
                                                        maxLines: null,
                                                        decoration: const InputDecoration(
                                                          border: InputBorder.none,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    );
                                  }),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height * 0.4,
                //   child: TextEditor(
                //     controller: controller,
                //     noteController: noteController,
                //   ),
                // ),
              ],
            ),
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

  Future rewindToPosition(time) async {
    String minute = time.split(':')[0];
    String second = time.split(':')[1];
    Duration rewind(Duration currentPosition) =>
        Duration(minutes: int.parse(minute), seconds: int.parse(second));
    await goToPosition(rewind);
  }

  Future goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final currentPosition = controller.currentVideoPosition;
    final newPosition = builder(currentPosition);
    await controller.videoSeekTo(newPosition);
  }
}
