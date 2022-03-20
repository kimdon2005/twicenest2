import 'package:flutter/material.dart';

tablelist() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        width: 70,
        height: 32,
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
            ),
          ),
          child: InkWell(
            child: Text('전체'),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      regulared('잡담', Colors.black),
      SizedBox(
        width: 85,
        height: 32,
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: new BorderRadius.only(),
          ),
          child: InkWell(
            child: Center(
              child: Text(
                '데이터',
                style: TextStyle(color: Colors.pink),
              ),
            ),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      regulared('정보', Colors.brown),
      SizedBox(
        width: 85,
        height: 32,
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: new BorderRadius.only(
              topRight: const Radius.circular(10.0),
            ),
          ),
          child: InkWell(
            child: Text('온에어'),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ],
  );
}

secondtable() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        width: 70,
        height: 32,
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(10.0),
            ),
          ),
          child: InkWell(
            child: Text('인증'),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      regulared('후기', Colors.black),
      SizedBox(
        width: 85,
        height: 32,
        child: Container(
          padding:
              const EdgeInsets.only(left: 10.6, right: 10.6, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
          ),
          child: InkWell(
            child: Center(child: Text('양도/교환')),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      regulared('공지', Colors.black),
      SizedBox(
        width: 85,
        height: 32,
        child: Container(
          padding:
              const EdgeInsets.only(left: 4.4, right: 4, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: new BorderRadius.only(
              bottomRight: const Radius.circular(10.0),
            ),
          ),
          child: InkWell(
            child: Center(
              child: Text(
                '할일/가이드',
                style: TextStyle(color: Colors.orange),
              ),
            ),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ],
  );
}

regulared(content, Color textcolor) {
  return SizedBox(
    width: 70,
    height: 32,
    child: Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
      ),
      child: InkWell(
        child: Text(
          content,
          style: TextStyle(color: textcolor),
        ),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
