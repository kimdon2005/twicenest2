import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int sign = 0;
int sign2 = 0;
int filenum = 0;

Future<void> downloadfile(
    String ___url, String filename, downloadedlist) async {
  if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    var _localPath = dir.path;
    final savedDir = Directory(_localPath);
    final status = await Permission.storage.request();
    downloadedlist.adddownloadedfile(_localPath + '/' + filename);
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
    // print(_localPath);
    final savedDir = Directory(_localPath);
    final status = await Permission.storage.request();
    downloadedlist.adddownloadedfile(_localPath + '/' + filename);
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

void makeRequest(_url, downloadedlist) async {
  List<String?> list = [];
  sign = 0;
  filenum = 0;

  list.clear();
  final response = await http.get(Uri.parse(_url));
  //If the http request is successful the statusCode will be 200
  if (response.statusCode == 200) {
    dom.Document document = parser.parse(response.body);
    final docu = document.getElementsByTagName('article');
    final datedocu = document
        .getElementsByClassName('date m_no')[0]
        .innerHtml
        .toString()
        .substring(0, 10)
        .replaceAll('.', '-');
    final docu2 =
        document.getElementsByTagName('article')[0].innerHtml.toString();
    var srcNum = 'img src'.allMatches(docu2).length;
    final usercol = FirebaseFirestore.instance
        .collection('filepath')
        .doc(datedocu)
        .collection('filepath');
    if (srcNum == 0) {
      srcNum = 'img alt'.allMatches(docu2).length;
    }
    try {
      for (int i = 0; i < srcNum; i++) {
        final e = docu
            .map((e) => e.getElementsByTagName("img")[i].attributes['src'])
            .toString();

        if (e.contains('files/')) {
          String filename =
              e.substring(e.lastIndexOf("/") + 1).replaceAll(')', ''); //파일이름 찾기
          var documentsnapshot =
              await usercol.doc(filename).get(); // firebase setting
          String imgurl = 'https://www.twicenestcontent.tk/images/' +
              documentsnapshot.data()!.values.toString(); //firebase에서 경로 찾고 넣기
          list.insert(i, imgurl.replaceAll('(', '').replaceAll(')', ''));
        } else {
          list.insert(i, e.replaceAll('(', '').replaceAll(')', ''));
        }
      }
    } catch (e) {
      for (int i = 0; i < srcNum; i++) {
        final e = docu
            .map((e) => e.getElementsByTagName("img")[i].attributes['src'])
            .toString();
        list.insert(
            i,
            'https://www.twicenest.com' +
                e.replaceAll('(', '').replaceAll(')', ''));
      }
    }

    list.remove('https://www.twicenest.com/static/blank.gif');
    filenum = list.length;
    for (int i = 0; i < filenum; i++) {
      String? imgurl = list[i];
      if (imgurl != null) {
        int length = imgurl.length;
        if (((imgurl.startsWith('https://drive.google.com/')) ==
                true & (imgurl.contains('.gif') == false)) ||
            (imgurl.startsWith('https://blogger.googleusercontent.com/')) ==
                true & (imgurl.contains('.gif') == false)) {
          sign2 = 0;
          String filename = imgurl
                  .substring(length - 15)
                  .replaceAll('https://', '')
                  .replaceAll('/', '') +
              '.gif';
          // print('next download start');
          downloadfile(imgurl, filename, downloadedlist);
          while (sign2 != 1) {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } else {
          sign2 = 0;
          String filename = imgurl
              .substring(length - 15)
              .replaceAll('https://', '')
              .replaceAll('/', '');
          // print('next download start');
          downloadfile(imgurl, filename, downloadedlist);
          // while (sign2 != 1) {
          //   print('wait');
          //   await Future.delayed(Duration(milliseconds: 500));
          // }
        }
      } else {
        print('error');
      }
    }
  }
}

Future<void> savefiletogallery(downloadedlist) async {
  List filelist = downloadedlist.list;
  int length = filelist.length;
  if (length != 0) {
    for (int i = 0; i < length; i++) {
      // try {
      //   // iOS
      //   if (Platform.isIOS) {
      //     final status = await Permission.photos.request();
      //     if (status.isGranted) {
      //       File file = await AddToGallery.addToGallery(
      //         originalFile: File(filelist[i]),
      //         albumName: '둥닷앱',
      //         deleteOriginalFile: true,
      //       );
      //       print("Savd to gallery with Path: ${file.path}");
      //     } else {
      //       throw ('permisson required');
      //     }
      //   }

      //   // Android (10 and below)
      //   if (Platform.isAndroid) {
      //     final status = await Permission.storage.request();
      //     if (status.isGranted) {
      //       File file = await AddToGallery.addToGallery(
      //         originalFile: File(filelist[i]),
      //         albumName: '둥닷앱',
      //         deleteOriginalFile: true,
      //       );
      //       print("Savd to gallery with Path: ${file.path}");
      //     } else {
      //       throw ('permisson required');
      //     }
      //   }
      // } catch (e) {
      //   print("Error: $e");
      // }
      try {
        // iOS
        if (!await Permission.photos.request().isGranted) {
          throw ('Permission Required?');
        }
        // Android (10 and below)
        if (!await Permission.storage.request().isGranted) {
          throw ('Permission Required');
        }
        // Add to the gallery
        File file = await AddToGallery.addToGallery(
          originalFile: File(filelist[i]),
          albumName: '둥닷앱',
          deleteOriginalFile: true,
        );
        print("Savd to gallery with Path: ${file.path}");
      } catch (e) {
        print("Error: $e");
      }
    }
    downloadedlist.clear();
  }
}

void signal() {
  sign = sign + 1;
  // print('sign = $sign');
  if (sign >= 2 * filenum - 1) {
    toast('모든 컨텐츠가 다운로드 되었습니다!!');
    // print('download finished');
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
