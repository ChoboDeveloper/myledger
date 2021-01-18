import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myledger/staticfunction.dart';
import 'dart:io';

class TagView extends StatefulWidget {
  TagView({this.arguments, this.arguments_flag});

  bool arguments_flag;
  String arguments;

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<TagView>{
  List<String> taglist;
  String filename;

  @override
  void initState() {
    taglist = [];
    if(widget.arguments_flag){
      filename = 'input'; readList(filename);}
    else{
      filename = 'output'; readList(filename);}
  }

  readList(String fn){
    File file = File('${staticfunction.appDocumentsDirectory.path}/DataSource/tags_$fn.txt');
    taglist.clear();

    if(!file.existsSync() ) {
      if(widget.arguments_flag == false) {
        taglist.add('식비');
        taglist.add('교통/차량');
        taglist.add('문화생활');
        taglist.add('마트/편의점');
        taglist.add('교육');
        taglist.add('생활용품');
        taglist.add('주거/통신');
        taglist.add('경조사/회비');
        taglist.add('기타');
        saveList(fn);
        readList(fn);
      }
      else{
        taglist.add('월급');
        taglist.add('부수입');
        taglist.add('용돈');
        taglist.add('상여');
        taglist.add('금융소득');
        taglist.add('기타');
        saveList(fn);
        readList(fn);
      }
      return;
    }

    String fileContent = file.readAsStringSync();
    for(int i=0; i<fileContent.split('\n').length-1;i++) {
      String inputStream;
      inputStream = fileContent.split('\n')[i];
      taglist.add(inputStream);
    }
  }

  saveList(String fn){
    File file = File('${staticfunction.appDocumentsDirectory.path}/DataSource/tags_$fn.txt');
    String inputStream = '';
    taglist.forEach((element) {
      inputStream += element + '\n';
    });
    file.writeAsString(inputStream);
  }

  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      width: 300.0,
      child: ListView.builder(
        itemCount: taglist.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(taglist[index]),
            onTap: (){
              widget.arguments = taglist[index];
              Navigator.pop(context, widget.arguments);},
            onLongPress: (){
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: const Text('삭제하기', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      onPressed: () {
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: const Text('취소하기', style: TextStyle(color: Colors.grey),),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}