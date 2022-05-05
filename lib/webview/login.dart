import 'package:flutter/material.dart';
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
          javascriptMode: JavascriptMode.disabled,
          navigationDelegate: (NavigationRequest request) {
            // if (request.url ==
            //     'https://platform.twitter.com/widgets/widget_iframe.a58e82e150afc25eb5372dd55a98b778.html?origin=https%3A%2F%2Fwww.twicenest.com') {
            //   Navigator.pop(context);
            // }
            // if (request.url
            //         .startsWith('https://www.twicenest.com/index/login') ==
            //     false) {
            //   if (Platform.isIOS) {
            //     i++;

            //     if (i >= 15) {
            //       print(i);

            //       i = 0;
            //       toast('로그인 상태입니다!!');
            //       Future.delayed(Duration(seconds: 1));
            //       Navigator.pop(context);
            //       return NavigationDecision.prevent;
            //     }
            //   } else {
            //     toast('로그인 상태입니다!!');
            //     Future.delayed(Duration(seconds: 1));
            //     Navigator.pop(context);
            //     return NavigationDecision.prevent;
            //   }
            // } else {
            //   // print('false!!');

            // }
            print(request.url);
            return NavigationDecision.navigate;
          }),
    ));
  }
}
