import 'dart:io';
import 'package:myledger/utils/format_function.dart';

class DataStructure{
  DateTime date;
  String amount, tag, subject, clr;

  DataStructure(){
    date = DateTime.now();
    amount = tag = subject = clr = '';
  }

  DataStructure.value(DateTime dt, String amount, String tag, String subject, String clr){
    this.date=dt;
    this.amount=amount;
    this.subject=subject;
    this.tag=tag;
    this.clr=clr;
  }
}

class DataList{
  List<DataStructure> datalist;
  String _filename;
  int total_in, total_out, total;

  DataList(){
    this.datalist = [];
    this._filename = 'none';
    this.total_in = 0;
    this.total_out = 0;
    this.total = 0;
  }

  addList(DateTime dt, String amount, String tag, String subject, String clr){
    datalist.add(DataStructure.value(dt, amount, tag, subject, clr));
  }

  saveList(String fn){
    _filename = fn;
    File file = File('${formatfunction.appDocumentsDirectory.path}/DataSource/$_filename.txt');

    String inputStream = '';
    datalist.forEach((element) {
      String _date,_amount,_tag,_subject,_flag;
      _date = formatfunction.getdateformat(element.date) + '#';
      _amount = element.amount + '#';
      _tag = element.tag + '#';
      _subject = element.subject + '#';
      _flag = element.clr + '\n';
      inputStream += _date+_amount+_tag+_subject+_flag;
    });
    file.writeAsString(inputStream);
  }

  saveOtherList(String fn, DataStructure element){
    _filename = fn;
    File file = File('${formatfunction.appDocumentsDirectory.path}/DataSource/$_filename.txt');
    String inputStream = '';

    String _date,_amount,_tag,_subject,_flag;
    _date = formatfunction.getdateformat(element.date) + '#';
    _amount = element.amount + '#';
    _tag = element.tag + '#';
    _subject = element.subject + '#';
    _flag = element.clr + '\n';
    inputStream += _date+_amount+_tag+_subject+_flag;

    file.writeAsString(inputStream, mode: FileMode.append);
  }

  readList(String fn){
    _filename = fn;
    File file = File('${formatfunction.appDocumentsDirectory.path}/DataSource/$_filename.txt');

    if(!file.existsSync()) {
      print(_filename+'.txt is not exist\n');
      return;
    }
    print(_filename+'.txt file is exist');
    String fileContent = file.readAsStringSync();

    if(fileContent.isEmpty) {
      print('$_filename.txt file is empty');
      return;
    }

    for(int i=0; i<fileContent.split('\n').length-1;i++) {
      String inputStream;
      String date, tag, amount, subject, clr;

      inputStream = fileContent.split('\n')[i];
      date = inputStream.split('#')[0];
      amount = inputStream.split('#')[1];
      tag = inputStream.split('#')[2];
      subject = inputStream.split('#')[3];
      clr = inputStream.split('#')[4];

      addList(DateTime.parse(date), amount, tag, subject, clr);
    }
  }

  getTotal(){
    total_in = total_out = total = 0;
    for(int i=0; i<datalist.length; i++){
      if(datalist[i].clr == 'green'){
        total_in += int.parse(datalist[i].amount);
      }
      else{
        total_out += int.parse(datalist[i].amount);
      }
    }
    total = total_in - total_out;
  }
}