import 'dart:io';
import 'package:myledger/utils/format_function.dart';

class TagList{
  List<String> taglist;
  String filename;

  TagList(){
    this.taglist = [];
    this.filename = '';
  }

  initlist(String fn){
    taglist.clear();
    if(fn == 'output') {
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
    }
    else{
      taglist.add('월급');
      taglist.add('부수입');
      taglist.add('용돈');
      taglist.add('상여');
      taglist.add('금융소득');
      taglist.add('기타');
      saveList(fn);
    }
  }

  readList(String fn){
    File file = File('${formatfunction.appDocumentsDirectory.path}/DataSource/tags_$fn.txt');

    if(!file.existsSync()){
      initlist(fn);
      readList(fn);
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
    File file = File('${formatfunction.appDocumentsDirectory.path}/DataSource/tags_$fn.txt');
    String inputStream = '';
    taglist.forEach((element) {
      inputStream += element + '\n';
    });
    file.writeAsString(inputStream);
  }
}