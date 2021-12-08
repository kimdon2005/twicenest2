import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'dart:io' show Platform;

List<String?> list = [];

Future<void> downloadfile(___url, filename) async {
  if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    var _localPath = dir.path;
    final savedDir = Directory(_localPath);
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await savedDir.create(recursive: true).then((value) async {
        await FlutterDownloader.enqueue(
          url: ___url,
          fileName: filename,
          savedDir: _localPath,
          showNotification: true,
          openFileFromNotification: true,
        );
      });
    } else {
      print("Permission deined");
    }

    //iOS
  } else if (Platform.isAndroid) {
    final dir = await getExternalStorageDirectory();
    var _localPath = dir!.path;
    final savedDir = Directory(_localPath);
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await savedDir.create(recursive: true).then((value) async {
        await FlutterDownloader.enqueue(
          url: ___url,
          fileName: filename,
          savedDir: _localPath,
          showNotification: true,
          openFileFromNotification: true,
        );
      });
    } else {
      print("Permission deined");
    }

    //Android
  }

  //From path_provider package
}

void makeRequest(_url) async {
  list.clear();
  final response = await http.get(Uri.parse(_url));
  //If the http request is successful the statusCode will be 200
  if (response.statusCode == 200) {
    dom.Document document = parser.parse(response.body);
    final docu = document.getElementsByTagName('article');
    final docu2 =
        document.getElementsByTagName('article')[0].innerHtml.toString();
    var srcNum = 'img src'.allMatches(docu2).length;
    var altNum = 'img alt'.allMatches(docu2).length;

    if (srcNum > 0 || altNum > 0) {
      for (int i = 0; i < srcNum; i++) {
        final e = docu
            .map((e) => e.getElementsByTagName("img")[i].attributes['src'])
            .toString();

        if (e.contains('files')) {
          String imgurl = 'https://www.twicenest.com' + e;
          list.insert(i, imgurl.replaceAll('(', '').replaceAll(')', ''));
        } else {
          list.insert(i, e.replaceAll('(', '').replaceAll(')', ''));
        }
      }

      for (int i = 0; i < altNum; i++) {
        final e = docu
            .map((e) => e.getElementsByTagName("img")[i].attributes['src'])
            .toString();
        if (e.contains('files')) {
          String imgurl = 'https://www.twicenest.com' + e;
          list.insert(i, imgurl.replaceAll('(', '').replaceAll(')', ''));
        } else {
          list.insert(i, e.replaceAll('(', '').replaceAll(')', ''));
        }
      }
    } else {
      print('zero to download');
    }

    list.remove('/static/blank.gif');
    final mappedlist = list.asMap();
    print(list);
    if (mappedlist[0] is String) {
      print('this var is string');
    }
    if (srcNum > 0 || altNum > 0) {
      for (int i = 0; i < srcNum; i++) {
        String? imgurl = mappedlist[i];
        if (imgurl != null) {
          int length = imgurl.length;

          downloadfile(
              mappedlist[i],
              mappedlist[i]!
                  .replaceAll('https://', '')
                  .replaceAll('/', '-')
                  .substring(length - 15));
        } else {
          print('error');
        }
      }
      for (int i = 0; i < altNum; i++) {
        int length = mappedlist[i]!.length;

        downloadfile(
            mappedlist[i],
            mappedlist[i]!
                .replaceAll('https://', '')
                .replaceAll('/', '-')
                .substring(length - 15));
      }
    } else {}
  }
}
