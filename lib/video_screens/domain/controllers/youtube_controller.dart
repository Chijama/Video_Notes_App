import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var ytProviderController = ChangeNotifierProvider<YoutubeProvider>((ref) => YoutubeProvider(ref));

class YoutubeProvider extends ChangeNotifier {
  final Ref ref;
  YoutubeProvider(this.ref);

  List<String> _taggedStamps = [];
  List<TextEditingController> controllers = [];

  List<String> get taggedStamps => _taggedStamps;
  // List<TextEditingController> get controllers => _controllers;

  set taggedStamps(List<String> value) {
    _taggedStamps = value;
    notifyListeners();
  }

  // set controllers(List<TextEditingController> value) {
  //   _controllers = value;
  //   notifyListeners();
  // }
}
