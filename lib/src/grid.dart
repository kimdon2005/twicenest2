import 'package:flutter/material.dart';
import 'package:twicenest2/provider/tabcounter.dart';

import '../provider/countprovider.dart';

Widget gridview(Tabchanger changer, Tabcounter counter) {
  return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, childAspectRatio: 2.0),
      delegate: SliverChildListDelegate(
        [
          box('전체', Colors.black54, 'https://www.twicenest.com/board', changer,
              counter),
          box(
              '잡담',
              Colors.black54,
              'https://www.twicenest.com/board/category/3627387',
              changer,
              counter),
          box(
              '데이터',
              Colors.pink,
              'https://www.twicenest.com/board/category/3627386',
              changer,
              counter),
          box(
              '정보',
              Colors.orange,
              'https://www.twicenest.com/board/category/3627415',
              changer,
              counter),
          box(
              '온에어',
              Colors.black54,
              'https://www.twicenest.com/board/category/3627381',
              changer,
              counter),
          box(
              '인증',
              Colors.black54,
              'https://www.twicenest.com/board/category/3627430',
              changer,
              counter),
          box(
              '후기',
              Colors.black54,
              'https://www.twicenest.com/board/category/3756885',
              changer,
              counter),
          box(
              '양도/교환',
              Colors.black54,
              'https://www.twicenest.com/board/category/3630578',
              changer,
              counter),
          box(
              '공지',
              Colors.black54,
              'https://www.twicenest.com/board/category/3627388',
              changer,
              counter),
          box(
              '할일/가이드',
              Colors.redAccent,
              'https://www.twicenest.com/board/category/7621807',
              changer,
              counter),
        ],
      ));
}

Widget box(content, color, taburl, Tabchanger changer, Tabcounter counter) {
  return InkWell(
    customBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    onTap: () {
      counter.settabnum(1);
      changer.changetab(taburl);
    },
    child: Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: new BorderRadius.all(Radius.circular(2)),
      ),
      child: Center(
        child: Text(
          content,
          style: TextStyle(color: color),
        ),
      ),
    ),
  );
}
