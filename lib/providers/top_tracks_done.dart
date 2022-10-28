import 'package:flutter/widgets.dart';

class TopTracksDone extends ChangeNotifier {
  bool _topTracksDone = false;
  bool get topTracksDone => _topTracksDone;

  set topTracksDone(bool value) {
    _topTracksDone = value;
    print('Inside setter; topTracksDone = $_topTracksDone');
    notifyListeners();
  }
}
