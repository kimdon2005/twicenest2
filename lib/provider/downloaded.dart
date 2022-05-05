import 'package:flutter/material.dart';

class Downloaded extends ChangeNotifier {
  List _downloadedfile = [];
  List get list => _downloadedfile;

  adddownloadedfile(filepath) {
    this._downloadedfile.add(filepath);
    notifyListeners();
  }

  clear() {
    this._downloadedfile.clear();
    print(_downloadedfile);
    notifyListeners();
  }
}
