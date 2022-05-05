import 'package:flutter/material.dart';

// ChangeNotifier 상속 받이 상태 관리
// 이 안에 있는 맴버 변수 값들을 상태 관리 한다.
class Tabchanger extends ChangeNotifier {
  String _url = 'https://www.twicenest.com/board';
  String get url => _url;

  // 더하기
  changetab(taburl) {
    this._url = taburl;
    notifyListeners(); // notifyListeners 호출해 업데이트된 값을 구독자에게 알림
  }
}
