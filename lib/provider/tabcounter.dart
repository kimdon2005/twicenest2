import 'package:flutter/material.dart';

class Tabcounter extends ChangeNotifier {
  int _i = 1;
  int get tabnum => _i;

  settabnum(num) {
    _i = num;
    notifyListeners();
  }
}
