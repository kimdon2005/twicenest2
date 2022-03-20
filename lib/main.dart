import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twicenest2/mainfeature/grid.dart';
import 'package:twicenest2/webview/login.dart';
import 'package:twicenest2/webview/write.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'functions/download.dart';
import 'first_terms.dart';
import 'secondpage.dart';
import 'functions/notification.dart';
import 'functions/calendar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp();
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
  bool visible = false;

  int count = 0;

  List<String?> list = []; // download url list

  Completer<WebViewController> _controller =
      Completer<WebViewController>(); //webview controller

  static int progress = 0; //download progress

  ReceivePort _receivePort = ReceivePort(); //init backgroun download

  FirebaseMessaging messaging =
      FirebaseMessaging.instance; //firebase message init

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
    acceptpermission().then((value) async {
      final token = await messaging.getToken() as String;
      saveTokenToDatabase(token);
    });

    super.initState();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      // print(progress);
      if (progress == 100) {
        signal();
        signal2();
      }
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  loadbool() async {
    final pref = await SharedPreferences.getInstance();
    // print(pref.getBool('permisson'));
    if (pref.getBool('permisson') == true) {
    } else {
      WidgetsBinding.instance?.addPostFrameCallback((_) => dialogging(context));
      pref.setBool('permisson', true);
    }
  }

  Future<void> firebaseCloudMessagingListeners() async {
    messaging.getToken().then((token) {
      saveTokenToDatabase(token as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: Color.fromRGBO(248, 247, 245, 10),
              title: Center(
                child: Text(
                  'TWICENEST',
                  style: TextStyle(
                      fontFamily: 'human',
                      color: Colors.black,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                      fontSize: 10),
                ),
              ),
              leading: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.bars,
                    color: Colors.black,
                  ),
                  onPressed: null),
              actions: [
                IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.lock,
                      size: 18,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Loginwebview()),
                      );
                    }),
                IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    onPressed: null),
              ],
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              blank(0, 20),
              Row(
                //first layer
                children: <Widget>[
                  blank(21, 0),
                  InkWell(
                    child: Text(
                      '트둥닷컴',
                      style: TextStyle(fontFamily: 'Jua', fontSize: 23),
                    ),
                    onTap: () {
                      print('home');
                    },
                  ),
                  blank(10, 0),
                  OutlinedButton(
                    onPressed: () {
                      print('추천글');
                    },
                    child: Text(
                      '추천글',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                    style: OutlinedButton.styleFrom(
                        fixedSize: const Size(20, 10),
                        primary: Colors.blueGrey,
                        backgroundColor: Colors.white24,
                        textStyle: const TextStyle(fontSize: 24)),
                  ),
                  Spacer(),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Writewebview()),
                        );
                      },
                      child: Text(
                        '🖊️쓰기',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      )),
                  blank(10, null)
                ],
              ), // first layer
              blank(null, 20),
              tablelist(),
              secondtable(),
              //grid view second layer
              // ListView(), //post view third layer
              Spacer(),
              Text('pageseletor') //page seletor fourth layer
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 4.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // backbutton(),
                Spacer(),
                // _buildShowUrlBtn(),
                gosecondpage(),
              ],
            ),
          ),
          floatingActionButton: schdule(),
        ),
        onWillPop: () => onWillPop());
  }

  blank(double? width, double? heith) {
    return SizedBox(
      width: width,
      height: heith,
    );
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
      },
      icon: Icon(Icons.download_done_rounded),
      tooltip: '다운로드된 파일 보기',
    );
  }

  Widget schdule() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return AnimatedOpacity(
            child: FloatingActionButton(
              backgroundColor: Color.fromRGBO(252, 237, 241, 10),
              foregroundColor: Colors.black45,
              child: Icon(Icons.event_available_rounded),
              tooltip: "스케줄을 캘린더로 복사!!",
              onPressed: !visible
                  ? null
                  : () async {
                      var url = await controller.data!.currentUrl();
                      setCurentLocation(url);
                    },
            ),
            duration: Duration(milliseconds: 100),
            opacity: visible ? 1 : 0,
          );
        }
        return Container();
      },
    );
  }
}
