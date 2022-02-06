import 'dart:io';

import 'package:flutter/material.dart';

import 'download.dart';

class Secondpage extends StatelessWidget {
  const Secondpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '다운받은 사진',
          style: TextStyle(color: Colors.black54, fontFamily: 'Jua'),
        ),
        backgroundColor: Color.fromRGBO(252, 237, 241, 10),
      ),
      body: filelist(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            savefiletogallery();
            if (Platform.isIOS) {
              final snackBar = SnackBar(
                content: const Text(
                  '다운받은 컨텐츠를 사진으로 이동중!!',
                  style: TextStyle(color: Colors.black54, fontFamily: 'Jua'),
                ),
                duration: new Duration(seconds: 1),
                backgroundColor: Color.fromRGBO(252, 237, 241, 10),
                elevation: 6.0,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
              );

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (Platform.isAndroid) {
              final snackBar = SnackBar(
                content: const Text(
                  '다운받은 컨텐츠를 갤러리로 이동중!!',
                  style: TextStyle(color: Colors.black54, fontFamily: 'Jua'),
                ),
                duration: new Duration(seconds: 1),
                backgroundColor: Color.fromRGBO(252, 237, 241, 10),
                elevation: 6.0,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
              );

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          backgroundColor: Color.fromRGBO(252, 237, 241, 10),
          foregroundColor: Colors.black45,
          tooltip: '다운받은 컨텐츠를 내 폰에 저장!!',
          child: Icon(Icons.folder_open_rounded)),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            gofirstscreen(context),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget filelist() {
    if (downloadedfile.length == 0) {
      return Center(
        child: Text(
          '다운 받은 파일이 없어요!!',
          style: TextStyle(color: Colors.black54, fontFamily: 'Jua'),
        ),
      );
    } else {
      try {
        return GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          crossAxisCount: 2,
          children: List.generate(downloadedfile.length, (index) {
            return Center(child: Image.file(File(downloadedfile[index])));
          }),
        );
      } catch (e) {
        toast('아직 모든 컨텐츠 다운로드 되지 않았어요!!');
      }

      return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        crossAxisCount: 2,
        children: List.generate(downloadedfile.length, (index) {
          return Center(child: Image.file(File(downloadedfile[index])));
        }),
      );
    }
  }

  Widget gofirstscreen(BuildContext context) {
    return InkWell(
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_rounded),
        tooltip: '원래 화면으로 돌아가기',
        autofocus: true,
      ),
    );
  }
}
