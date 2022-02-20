import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> dialogging(context) async {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text(
            '앱 이용약관',
            style: TextStyle(fontFamily: 'Jua', color: Colors.black87),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '앱 이용 약관에 동의하십니까?',
                  style: TextStyle(
                      fontSize: 15, fontFamily: 'Jua', color: Colors.black54),
                ),
                Material(
                  child: InkWell(
                      child: Text(
                        '이용 약관 및 사용자 정책',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Jua',
                            color: Colors.black54),
                      ),
                      onTap: () {
                        showterms(context);
                      }),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '허용',
                style: TextStyle(fontFamily: 'Jua', color: Colors.blueAccent),
              ),
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                pref.setBool('permisson', true);
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
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text(
            '앱 이용약관',
            style: TextStyle(fontFamily: 'Jua', color: Colors.black87),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '앱 이용 약관에 동의하십니까?',
                  style: TextStyle(
                      fontSize: 15, fontFamily: 'Jua', color: Colors.black54),
                ),
                Material(
                  child: InkWell(
                      child: Text(
                        '이용 약관 및 사용자 정책',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Jua',
                            color: Colors.black54),
                      ),
                      onTap: () {
                        showterms(context);
                      }),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '허용',
                style: TextStyle(fontFamily: 'Jua', color: Colors.blueAccent),
              ),
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                pref.setBool('permisson', true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

showterms(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        final double radius = 8;
        final String mdFileName = "policy.md";
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future:
                      Future.delayed(Duration(milliseconds: 150)).then((value) {
                    return rootBundle.loadString('assets/$mdFileName');
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Markdown(
                        data: snapshot.data as String,
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(239, 239, 239, 10),
                  primary: Color.fromRGBO(239, 239, 239, 0),
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                  ),
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  child: Text(
                    "CLOSE",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.button?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
