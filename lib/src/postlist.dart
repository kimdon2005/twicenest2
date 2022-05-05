import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:twicenest2/webview/postview.dart';

List<Map<dynamic, dynamic>?> list = [];

Widget postlist(url) {
  return FutureBuilder<List<Map<dynamic, dynamic>?>>(
      future: makelist(url),
      builder: (BuildContext context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none) {
          return SliverToBoxAdapter(child: Container());
        } else if (projectSnap.hasError) {
          return SliverToBoxAdapter(child: Container());
        } else if (projectSnap.connectionState == ConnectionState.done) {
          return SliverList(
              // padding: const EdgeInsets.all(8),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            final postelment = projectSnap.data![index];
            if (postelment!['no'].toString().trim() == '공지') {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Postview(),
                      settings: RouteSettings(
                        arguments:
                            'https://www.twicenest.com' + postelment['url'],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 7, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(242, 242, 242, 10),
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Container(
                    child: Text(
                      postelment['title'],
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'nanum',
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(50, 101, 141, 10)),
                    ),
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Postview(),
                    settings: RouteSettings(
                      arguments:
                          'https://www.twicenest.com' + postelment['url'],
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 12, top: 8, bottom: 12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(246, 255, 255, 255),
                  border: Border.all(
                    color: Colors.black12,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              child: Text(
                                postelment['title'].toString().trim(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'nanum',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          IntrinsicHeight(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  cate(postelment['cate']),
                                  VerticalDivider(
                                    color: Colors.black,
                                    thickness: 0.1,
                                  ),
                                  Text(
                                    postelment['time'],
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 13),
                                  ),
                                  VerticalDivider(
                                    color: Colors.black,
                                    thickness: 0.1,
                                  ),
                                  Text(
                                    '조회 ' + postelment['views'],
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 13),
                                  ),
                                  VerticalDivider(
                                    color: Colors.black,
                                    thickness: 0.1,
                                  ),
                                  Text(
                                    '추천 ' + postelment['recommend'],
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 13),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Center(
                              child: Text(
                            postelment['comments'],
                            style: TextStyle(
                                color: Color.fromRGBO(75, 108, 214, 10)),
                          )),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color.fromRGBO(242, 242, 242, 10)),
                        ))
                  ],
                ),
              ),
            );
          }, childCount: projectSnap.data!.length));
          // return Container(
          //   child: Text('test'),
          // );
        } else {
          return SliverToBoxAdapter(child: CircularProgressIndicator());
        }
      });
}

Widget cate(cate) {
  if (cate == '데이터') {
    return Text(
      '데이터',
      style: TextStyle(color: Colors.pink, fontSize: 13),
    );
  } else {
    return Text(
      cate,
      style: TextStyle(color: Colors.black54, fontSize: 13),
    );
  }
}

Future<List<Map<dynamic, dynamic>?>> makelist(url) async {
  final _url = url;
  list.clear();
  final response = await http.get(Uri.parse(_url));
  if (response.statusCode == 200) {
    dom.Document document = parser.parse(response.body);
    final no = document.getElementsByClassName('no');
    final cate = document.getElementsByClassName('cate');
    final title = document.getElementsByClassName('title');
    final author = document.getElementsByClassName('author');
    final time = document.getElementsByClassName('time');
    final mMo = document.getElementsByClassName('m_no');
    final url = title
        .map((e) => e.getElementsByTagName("a")[0].attributes['href'])
        .toList();
    for (int i = 0; i < cate.length; i++) {
      var comments = title[i + 1].children[1].text;
      if (comments == '') {
        comments = '0';
      }
      list.add({
        'no': no[i + 1].text,
        'cate': cate[i].text,
        'title': title[i + 1].children[0].text,
        'author': author[i].text,
        'time': time[i].text,
        'views': mMo[2 * i + 4].text,
        'recommend': mMo[2 * i + 5].text,
        'comments': comments,
        'url': url[i + 1],
      });
    }
    return list;
  } else {
    return list;
  }
}
