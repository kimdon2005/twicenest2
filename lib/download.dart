import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;  
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
    
List<String?> list = [];

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