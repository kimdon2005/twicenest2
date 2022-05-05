import 'package:flutter/material.dart';
import 'package:twicenest2/webview/postview.dart';

Widget drawer(context) {
  return Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromRGBO(248, 247, 245, 10),
          ),
          child: Center(
              child: Text(
            'TWICENEST',
            style: TextStyle(
                fontFamily: 'human',
                color: Colors.black,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w700,
                fontSize: 11),
          )),
        ),
        ListTile(
          title: text('홈'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Postview(),
                settings: RouteSettings(
                  arguments: 'https://www.twicenest.com',
                ),
              ),
            );
            // Update the state of the app.
            // ...
          },
        ),
        Divider(),
        ListTile(
          title: text('공지'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Postview(),
                settings: RouteSettings(
                  arguments: 'https://www.twicenest.com/notice',
                ),
              ),
            );
            // Update the state of the app.
            // ...
          },
        ),
        Divider(),
        ListTile(
          title: text('스케줄'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Postview(),
                settings: RouteSettings(
                  arguments: 'https://www.twicenest.com/schedule',
                ),
              ),
            );
            // Update the state of the app.
            // ...
          },
        ),
        Divider(),
        ListTile(
          title: text('트둥토크'),
          onTap: () {
            Navigator.pop(context);

            // Update the state of the app.
            // ...
          },
        ),
        Divider(),
        ListTile(
          title: text('문의'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Postview(),
                settings: RouteSettings(
                  arguments: 'https://www.twicenest.com/support',
                ),
              ),
            );
            // Update the state of the app.
            // ...
          },
        ),
        Divider(),
        ListTile(
          title: text('둥닷콘'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Postview(),
                settings: RouteSettings(
                  arguments: 'https://www.twicenest.com/sticker',
                ),
              ),
            );
            // Update the state of the app.
            // ...
          },
        ),
        Divider(),
        ListTile(
          title: text('가위바위보'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Postview(),
                settings: RouteSettings(
                  arguments: 'https://www.twicenest.com/rockgame',
                ),
              ),
            );
            // Update the state of the app.
            // ...
          },
        ),
        Divider(),
      ],
    ),
  );
}

Widget text(text) {
  return Text(text,
      style: TextStyle(fontFamily: 'nanum', fontWeight: FontWeight.w800));
}
