import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:add_to_gallery/add_to_gallery.dart';

List downloadedfile = [];
int sign = 0;
int sign2 = 0;
int filenum = 0;

Future<void> downloadfile(___url, filename) async {
  if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    var _localPath = dir.path;
    final savedDir = Directory(_localPath);
    final status = await Permission.storage.request();
    downloadedfile.add(_localPath + '/' + filename);
    if (status.isGranted) {
      await savedDir.create(recursive: true).then((value) async {
        await FlutterDownloader.enqueue(
          url: ___url,
          fileName: filename,
          savedDir: _localPath,
        );
      });
    } else {
      print("Permission deined");
    }

    //iOS

  } else if (Platform.isAndroid) {
    final dir = await getExternalStorageDirectory();
    var _localPath = dir!.path;
    print(_localPath);
    final savedDir = Directory(_localPath);
    final status = await Permission.storage.request();
    downloadedfile.add(_localPath + '/' + filename);
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
  List<String?> list = [];
  sign = 0;
  filenum = 0;

  list.clear();
  final response = await http.get(Uri.parse(_url));
  //If the http request is successful the statusCode will be 200
  if (response.statusCode == 200) {
    dom.Document document = parser.parse(response.body);
    final docu = document.getElementsByTagName('article');
    final docu2 =
        document.getElementsByTagName('article')[0].innerHtml.toString();
    var srcNum = 'src'.allMatches(docu2).length;
    print('srcnum = $srcNum');

    for (int i = 0; i < srcNum; i++) {
      final e = docu
          .map((e) => e.getElementsByTagName("img")[i].attributes['src'])
          .toString();

      if (e.contains('files/')) {
        String filename = e.substring(e.lastIndexOf("/") + 1);
        String imgurl = 'https://www.twicenestcontent.tk/1/' + filename;
        list.insert(i, imgurl.replaceAll('(', '').replaceAll(')', ''));
      } else {
        list.insert(i, e.replaceAll('(', '').replaceAll(')', ''));
      }
    }
    if (list.contains('/static/blank.gif')) {
      filenum = srcNum - 1;
    } else {
      filenum = srcNum;
    }
    list.remove('/static/blank.gif');
    print(list);
    if (list[0] is String) {
      print('this var is string');
    }
    for (int i = 0; i < filenum; i++) {
      String? imgurl = list[i];
      if (imgurl != null) {
        int length = imgurl.length;
        if ((imgurl.startsWith('https://drive.google.com/')) ==
            true & (imgurl.contains('.gif') == false)) {
          sign2 = 0;
          String filename = imgurl
                  .substring(length - 15)
                  .replaceAll('https://', '')
                  .replaceAll('/', '') +
              '.gif';
          print('next download start');
          downloadfile(imgurl, filename);
          while (sign2 != 1) {
            print('wait for 500milliseconds');
            await Future.delayed(Duration(milliseconds: 500));
          }
        } else {
          sign2 = 0;
          String filename = imgurl
              .substring(length - 15)
              .replaceAll('https://', '')
              .replaceAll('/', '');
          await Future.delayed(Duration(seconds: 1));
          print('next download start');
          downloadfile(imgurl, filename);
          while (sign2 != 1) {
            print('wait for 500milliseconds');
            await Future.delayed(Duration(milliseconds: 500));
          }
        }
      } else {
        print('error');
      }
    }
  }
}

Future<void> savefiletogallery() async {
  int length = downloadedfile.length;
  if (length != 0) {
    for (int i = 0; i < length; i++) {
      try {
        // iOS
        if (!await Permission.photos.request().isGranted) {
          throw ('Permission Required');
        }
        // Android (10 and below)
        if (!await Permission.storage.request().isGranted) {
          throw ('Permission Required');
        }
        // Add to the gallery
        File file = await AddToGallery.addToGallery(
          originalFile: File(downloadedfile[i]),
          albumName: '둥닷앱',
          deleteOriginalFile: true,
        );
        print("Savd to gallery with Path: ${file.path}");
      } catch (e) {
        print("Error: $e");
      }
    }
    downloadedfile.clear();
  }
}

void signal() {
  sign = sign + 1;
  print('sign = $sign');
  if (sign >= 2 * filenum - 1) {
    toast('모든 컨텐츠가 다운로드 되었습니다!!');
    print('download finished');
  }
}

void signal2() {
  if (sign % 2 == 1) {
    sign2 = 1;
  }
}

void toast(message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Color.fromRGBO(252, 237, 241, 10),
    textColor: Colors.black87,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    fontSize: 15,
    timeInSecForIosWeb: 1,
  );
}

Future<void> dialogging(context) async {
  if (Platform.isAndroid) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
