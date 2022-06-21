import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '/models/notes.dart';
import '/video_screens/network.dart';
import '/video_screens/vimeo.dart';
import '/video_screens/youtube.dart';
import '../widgets/note_item.dart';

class FolderNotesScreen extends StatefulWidget {
  static const routeName = '/folder-notes';
  final String noteId;
  final String folderTitle;
  final Color globalColor;
  FolderNotesScreen(
      {required this.noteId, required this.folderTitle, required this.globalColor, Key? key})
      : super(key: key);

  //const FolderNotesScreen({super.key});

  @override
  State<FolderNotesScreen> createState() => _FolderNotesScreenState();
}

class _FolderNotesScreenState extends State<FolderNotesScreen> {
  final youtubeurlcontroller = TextEditingController();
  final vimeourlcontroller = TextEditingController();
  final networkurlcontroller = TextEditingController();

  final List<Note> _userNotes = [];
  Future localVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result == null)
      return;
    else {
      File file = File(result.files.single.path.toString());
      print(file.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => PlayVideoFromLocalMedia(
                    filePath: file,
                  ))));
    }
  }

  Future youtubeUrl() => showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enter Youtube URL'),
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
                  style: ElevatedButton.styleFrom(primary: widget.globalColor),
                  onPressed: () async {
                    if (youtubeurlcontroller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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
                                    youtubeVideoUrl: youtubeurlcontroller.text,
                                  ))));

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
                  style: ElevatedButton.styleFrom(primary: widget.globalColor),
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
                              builder: ((context) =>
                                  PlayVideoFromVimeo(vimeoVideoId: vimeourlcontroller.text))));

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderTitle),
        backgroundColor: widget.globalColor,
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: widget.globalColor,
            child: IconButton(
              icon: Icon(Icons.play_circle_outlined, color: Colors.white),
              tooltip: 'Youtube',
              onPressed: () => youtubeUrl(),
            ),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: widget.globalColor,
            child: IconButton(
              icon: Icon(Icons.video_call_sharp, color: Colors.white),
              tooltip: 'Vimeo',
              onPressed: () => vimeoUrl(),
            ),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: widget.globalColor,
            child: IconButton(
              icon: Icon(Icons.upload_outlined, color: Colors.white),
              tooltip: 'Local Media',
              onPressed: () => localVideo(),
            ),
          ),
        ],
      ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        children: _userNotes
            .map(
              (catData) => NoteItem(
                catData.noteTitle,
                catData.fldNoteColor,
                catData.noteId,
                catData.createdAt,
              ),
            )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0; i < count; i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
    required this.tooltip,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.secondary,
      ),
    );
  }
}
