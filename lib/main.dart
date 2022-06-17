import 'package:flutter/material.dart';
import 'package:speech_to_text/video_screens/network.dart';
import 'video_screens/youtube.dart';
import 'video_screens/vimeo.dart';
import 'video_screens/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(),
        routes: {
          //'/fromVimeoId': (context) => const PlayVideoFromVimeo(),
          '/fromNetwork': (context) => const PlayVideoFromNetwork(),
          //LoadYoutubeUrl.routeName:(context) => const LoadYoutubeUrl(),
          // '/fromYoutube': (context) => PlayVideoFromYoutube(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final youtubeurlcontroller = TextEditingController();
  final vimeourlcontroller = TextEditingController();
  final networkurlcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: Icon(Icons.file_upload, color: Colors.white),
                        tooltip: 'Upload file',
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/fromNetwork'),
                      ),
                    ),
                    Text(
                      'Play video from Local Media',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: Icon(Icons.youtube_searched_for_sharp,
                            color: Colors.white),
                        tooltip: 'Youtube',
                        onPressed: () => youtubeUrl(),
                      ),
                    ),
                    Text(
                      'Play video from Youtube',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: Icon(Icons.abc, color: Colors.white),
                        tooltip: 'Vimeo',
                        onPressed: () => vimeoUrl(),
                      ),
                    ),
                    Text(
                      'Play video from Vimeo',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future youtubeUrl() => showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Enter Youtube URL'),
          content: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: youtubeurlcontroller,
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
                    if (youtubeurlcontroller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter url'),
                        ),
                      );
                      return;
                    } else {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PlayVideoFromYoutube(
                                  youtubeVideoUrl:
                                      youtubeurlcontroller.text))));

                      return;
                    }
                  },
                  child: const Text('Load Video'),
                ),
              ),
            ],
          ),
        ),
      );
  Future vimeoUrl() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: vimeourlcontroller,
                  decoration: const InputDecoration(
                    labelText: 'Enter vimeo id',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'ex: 518228118',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FocusScope(
                canRequestFocus: false,
                child: ElevatedButton(
                  onPressed: () async {
                    if (youtubeurlcontroller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter id'),
                        ),
                      );
                      return;
                    } else {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PlayVideoFromVimeo(
                                  vimeoVideoId: vimeourlcontroller.text))));

                      return;
                    }
                  },
                  child: const Text('Load Video'),
                ),
              ),
            ],
          ),
        ),
      );
}


// /fromYoutube',
//                           arguments: {'link': youtubeurlcontroller}