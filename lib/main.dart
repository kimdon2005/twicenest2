import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'download.dart';
import 'secondpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Twicenest());
  }
}

class Twicenest extends StatefulWidget {
  Twicenest({Key? key}) : super(key: key);

  @override
  _TwicenestState createState() => _TwicenestState();
}

class _TwicenestState extends State<Twicenest> {
  List<String?> list = [];

  Completer<WebViewController> _controller = Completer<WebViewController>();

  static int progress = 0;

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    //0/ssending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    loadbool().then((value) {});

    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
      if (progress == 100) {
        signal();
        signal2();
      }
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  loadbool() async {
    final pref = await SharedPreferences.getInstance();
    print(pref.getBool('permisson'));
    if (pref.getBool('permisson') == true) {
    } else {
      WidgetsBinding.instance?.addPostFrameCallback((_) => dialogging(context));
      pref.setBool('permisson', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Color.fromRGBO(248, 247, 245, 10),
            child: SafeArea(
              top: true,
              child: WebView(
                  initialUrl: 'https://www.twicenest.com/board',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    _controller.future.then((value) =>
                        _controller = value as Completer<WebViewController>);
                  }),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 4.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                backbutton(),
                Spacer(),
                _buildShowUrlBtn(),
                gosecondpage(),
              ],
            ),
          ),
        ),
        onWillPop: () => onWillPop());
  }

  late DateTime backbuttonpressedTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton =
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "앱 종료를 원하면 더블 클릭을 하세요!!",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }

  Widget _buildShowUrlBtn() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return IconButton(
            onPressed: () async {
              var url = await controller.data!.currentUrl();
              try {
                // downloadfile(
                //     'https://www.drive.google.com/uc?export=download&id=1SWQJmyY2KKG22Lax-H0V5Qc5JksASeA9',
                //     'test.gif');
                makeRequest(url);
                final snackBar = SnackBar(
                  content: const Text(
                    '컨텐츠를 다운로드 중!!',
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
              } catch (e) {
                final snackBar = SnackBar(
                  content: const Text(
                    '다운할 컨텐츠가 없어요!!',
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
            icon: Icon(Icons.download_rounded),
            tooltip: '페이지의 파일 다운로드',
            autofocus: true,
          );
        }
        return Container();
      },
    );
  }

  Widget backbutton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  controller.data!.goBack();
                });
          }

          return Container();
        });
  }

  Widget gosecondpage() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Secondpage(),
          ),
        );
        // dialogging(context);
      },
      icon: Icon(Icons.download_done_rounded),
      tooltip: '다운로드된 파일 보기',
    );
  }
}
