import 'package:flutter/material.dart';
import 'package:twicenest2/provider/countprovider.dart';
import 'package:twicenest2/provider/tabcounter.dart';

Widget tabselecter(Tabchanger changer, Tabcounter counter) {
  int i = counter.tabnum;
  return SliverToBoxAdapter(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      selectbutton(1, counter, changer),
      selectbutton(i + 1, counter, changer),
      selectbutton(i + 2, counter, changer),
      selectbutton(i + 3, counter, changer),
      selectbutton(i + 4, counter, changer)
    ],
  ));
}

Widget selectbutton(int number, Tabcounter counter, Tabchanger changer) {
  final posturl = changer.url;
  return GestureDetector(
    onTap: () {
      if (posturl.contains('page')) {
        changer.changetab(posturl.substring(0, posturl.lastIndexOf('/') + 1) +
            number.toString());
      } else {
        print(posturl);
        changer.changetab(posturl + '/page/$number');
      }
      // changer.changetab();
      counter.settabnum(number);
    },
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.black38),
      ),
      child: Center(child: Text(number.toString())),
    ),
  );
}
