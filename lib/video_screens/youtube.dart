import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pod_player/pod_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:speech_to_text/buttons_bar.dart';
import 'package:speech_to_text/video_screens/domain/controllers/youtube_controller.dart';

class PlayVideoFromYoutube extends StatefulWidget {
  const PlayVideoFromYoutube({Key? key, required this.youtubeVideoUrl}) : super(key: key);

  final String youtubeVideoUrl;
  // static const routeName = '/youtube-screen';
  @override
  State<PlayVideoFromYoutube> createState() => _PlayVideoFromYoutubeState();
}

class _PlayVideoFromYoutubeState extends State<PlayVideoFromYoutube> {
  late final PodPlayerController controller;
  final videoTextFieldCtr = TextEditingController();
  final screenshot_Controller = ScreenshotController();
  final TextEditingController noteController = TextEditingController();
  GlobalKey previewContainer = GlobalKey();
  //  = List.generate(34, (i) => TextEditingController());

  void loadVideo() async {
    await controller.changeVideo(playVideoFrom: PlayVideoFrom.youtube(widget.youtubeVideoUrl));
  }

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
    controller = PodPlayerController(playVideoFrom: PlayVideoFrom.youtube(widget.youtubeVideoUrl))
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
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Consumer(builder: (_, ref, __) {
            return Column(
              children: [
                RepaintBoundary(
                  key: previewContainer,
                  child: PodVideoPlayer(
                    controller: controller,
                    videoThumbnail: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dW5zcGxhc2h8ZW58MHx8MHx8&w=1000&q=80',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  // height: 700,
                  child: Column(
                    children: [
                      Progress(
                        previewContainer: previewContainer,
                        screenshotController: screenshot_Controller,
                        controller: controller,
                        noteController: noteController,
                        filePath: "",
                        youtubeProvider: ref.watch(ytProviderController),
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
                ),
              ],
            );
          }),
        ),
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
