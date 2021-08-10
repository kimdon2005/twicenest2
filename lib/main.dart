import 'dart:async';
import 'dart:io';

import 'dart:isolate';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  
  runApp(MyApp());}



class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,  
      home: Example_app()

      
    );
  }
}

class Example_app extends StatefulWidget {
  Example_app({Key? key}) : super(key: key);

  @override
  _Example_appState createState() 
  => _Example_appState();
}

class _Example_appState extends State<Example_app> {
  List<String?> list = [];

 

  Completer<WebViewController> _controller = Completer<WebViewController>();
 
   int progress = 0;
 
  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    //0/ssending the data
    sendPort!.send([id, status, progress]);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      print(progress);
    });



    FlutterDownloader.registerCallback(downloadingCallback);
  }


  @override
  Widget build(BuildContext context) {
   
    return  WillPopScope (
      child : Scaffold(
      resizeToAvoidBottomInset: false,
      body:  WebView(
          initialUrl: 'https://www.twicenest.com/board',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          _controller.future.then((value) => _controller = value as Completer<WebViewController>);
          }
        ),  

       bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            backbutton(),
            _buildShowUrlBtn()
          ],
        ),
      ),  
       
 
      
      

            ), onWillPop: () 
            => onWillPop()
          
          );
        }
      

   
   
    late DateTime backbuttonpressedTime;  

    Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
   bool backButton = currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

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



    Future<void> downloadfile(___url, filename) async{
      final dir =
        await getExternalStorageDirectory(); 
        //From path_provider package
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
   
   });}
   
  else {
                    print("Permission deined");
                      }
      }
        
    void makeRequest(_url) async{
      list.clear();
      final response = await http.get(Uri.parse(_url));
      //If the http request is successful the statusCode will be 200
      if(response.statusCode == 200){
      
        dom.Document document = parser.parse(response.body);
        final docu = document.getElementsByTagName('article');
        final docu2 = document.getElementsByTagName('article')[0].innerHtml.toString();
        var a = 'img src'.allMatches(docu2).length;
        var b = 'img alt'.allMatches(docu2).length;
        
        
        if (a>0){
         for (int i = 0; i < a; i++) {
           
           final e = docu.map((e) => 
          e.getElementsByTagName("img")[i].attributes['src']).toString();
           if (e.contains('files')) {
            String imgurl = 'https://www.twicenest.com' + e;
            list.insert(i, imgurl.replaceAll('(', '').replaceAll(')', ''));
            }
           else{
              list.insert(i, e.replaceAll('(', '').replaceAll(')', ''));
            } 
          }
          }
          else {
           for (int i = 0; i < b; i++){
            final e = docu.map((e) => 
            e.getElementsByTagName("img")[i].attributes['src']).toString();
            if (e.contains('files')) {
             String imgurl = 'https://www.twicenest.com' + e;
             list.insert(i, imgurl.replaceAll('(', '').replaceAll(')', ''));
             }
            else{
              list.insert(i, e.replaceAll('(', '').replaceAll(')', ''));
            } 
            }
           }
             
           
         list.remove('/static/blank.gif');
         final mappedlist = list.asMap();
             
      
      if (a>0){
             for (int i = 0; i < a; i++) {
             int length =  mappedlist[i]!.replaceAll('https://', '').replaceAll('/', '-').length;
              
              downloadfile(mappedlist[i], mappedlist[i]!.replaceAll('https://', '').replaceAll('/', '-').substring(length-15, length) );
              
      
              }
              }
              else {
               for (int i = 0; i < b; i++){
               int length =  mappedlist[i]!.replaceAll('https://', '').replaceAll('/', '-').length;
               
               downloadfile(mappedlist[i], mappedlist[i]!.replaceAll('https://', '').replaceAll('/', '-').substring(length-15, length));
               
               }
      
              }
        
      
             
      }
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
                      makeRequest(url);
                      
                  },
                  icon: Icon(Icons.download),
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
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    controller.data!.goBack();
                  });
            }

            return Container();
          }
      );
        }
      
      
      
      }





