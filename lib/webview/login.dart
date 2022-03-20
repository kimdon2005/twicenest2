import 'dart:io';

import 'package:flutter/material.dart';
import '../functions//download.dart';
import 'package:webview_flutter/webview_flutter.dart';

int i = 0;

class Loginwebview extends StatelessWidget {
  const Loginwebview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      child: WebView(
          initialUrl: 'https://www.twicenest.com/index/login',
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                    .startsWith('https://www.twicenest.com/index/login') ==
                false) {
              if (Platform.isIOS) {
                i++;
                print(i);
                print(request.url);

                if (i >= 7) {
                  i = 0;
                  toast('로그인 상태입니다!!');
                  Future.delayed(Duration(seconds: 1));
                  Navigator.pop(context);
                  return NavigationDecision.prevent;
                }
              } else {
                toast('로그인 상태입니다!!');
                Future.delayed(Duration(seconds: 1));
                Navigator.pop(context);
                return NavigationDecision.prevent;
              }
            } else {
              // print('false!!');

            }

            return NavigationDecision.navigate;
          }),
    ));
  }
}
