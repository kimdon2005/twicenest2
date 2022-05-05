import 'dart:io';

import 'package:flutter/material.dart';
import 'package:twicenest2/functions//download.dart';
import 'package:webview_flutter/webview_flutter.dart';

int i = 0;

class Writewebview extends StatelessWidget {
  const Writewebview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WebView(
              initialUrl: 'https://www.twicenest.com/board/write',
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                if (request.url
                        .startsWith('https://www.twicenest.com/board/write') ==
                    false) {
                  if (Platform.isIOS) {
                    print(request.url);
                    i++;

                    if (i >= 4) {
                      i = 0;
                      toast('글을 작성하였습니다!!');
                      Navigator.pop(context);
                      return NavigationDecision.prevent;
                    }
                  } else {
                    toast('글을 작성하였습니다!!');
                    Navigator.pop(context);
                    return NavigationDecision.prevent;
                  }
                } else {}

                return NavigationDecision.navigate;
              })),
    );
  }
}
