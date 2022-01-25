import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:add_to_gallery/add_to_gallery.dart';

List<String?> list = [];
List downloadedfile = [];
int sign = 0;

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

        if (e.contains('files/')) {
          String filename = e.substring(e.lastIndexOf("/") + 1);
          String imgurl =
              'https://twicenest-content.koreacentral.cloudapp.azure.com/3/' +
                  filename;
          list.insert(i, imgurl.replaceAll('(', '').replaceAll(')', ''));
        } else {
          list.insert(i, e.replaceAll('(', '').replaceAll(')', ''));
        }
      }

      for (int i = 0; i < altNum; i++) {
        final e = docu
            .map((e) => e.getElementsByTagName("img")[i].attributes['src'])
            .toString();
        if (e.contains('files/')) {
          String filename = e.substring(e.lastIndexOf("/") + 1);
          String imgurl =
              'https://twicenest-content.koreacentral.cloudapp.azure.com/3/' +
                  filename;
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
          if ((imgurl.startsWith('https://drive.google.com/')) ==
              true & (imgurl.contains('.gif') == false)) {
            sign = 0;
            String filename = imgurl
                    .substring(length - 15)
                    .replaceAll('https://', '')
                    .replaceAll('/', '') +
                '.gif';
            downloadfile(imgurl, filename);
            print(imgurl);
            print(filename);
            print(length);
            while (sign == 1) {
              sleep(const Duration(seconds: 10));
            }
          } else {
            sign = 0;
            String filename = imgurl
                .substring(length - 15)
                .replaceAll('https://', '')
                .replaceAll('/', '');
            downloadfile(imgurl, filename);
            print(imgurl);
            print(filename);
            print(length);
            while (sign == 1) {
              sleep(const Duration(seconds: 10));
            }
          }
        } else {
          print('error');
        }
      }
      for (int i = 0; i < altNum; i++) {
        String? lastImgurl = mappedlist[i];
        int length = lastImgurl!.length;

        if ((lastImgurl.startsWith('https://drive.google.com/')) ==
            true & (lastImgurl.contains('.gif') == false)) {
          sign = 0;
          String filename = lastImgurl
                  .substring(length - 15)
                  .replaceAll('https://', '')
                  .replaceAll('/', '') +
              '.gif';
          downloadfile(lastImgurl, filename);
          print(lastImgurl);
          print(filename);
          print(length);
          while (sign == 1) {
            sleep(const Duration(seconds: 10));
          }
        } else {
          sign = 0;
          String filename = lastImgurl
              .substring(length - 15)
              .replaceAll('https://', '')
              .replaceAll('/', '');
          downloadfile(lastImgurl, filename);
          print(lastImgurl);
          print(filename);
          print(length);
          while (sign == 1) {
            sleep(const Duration(seconds: 10));
          }
        }
      }
    } else {}
  }
}

void signal() {
  sign = 1;
}

Future<void> savefiletogallery() async {
  int length = downloadedfile.length;
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
}
