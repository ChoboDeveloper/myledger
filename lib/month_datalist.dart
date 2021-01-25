import 'dart:io';
import 'package:myledger/staticfunction.dart';

class MonthDataStructure{
  int income, outcome;

  MonthDataStructure(int i, int o){
    this.income = i;
    this.outcome = o;
  }

  String get_income(){
    return income.toString();
  }

  String get_outcome(){
    return outcome.toString();
  }

  add_value(int val){
    this.income += val;
  }

  sub_value(int val){
    this.outcome += val;
  }
}

class MonthDataList{
  List<MonthDataStructure> monthdatalist; // 12 months[income, outcome]
  String _filename;
  int income_year, outcome_year; // Annual income & outcome

  MonthDataList(){
    this.monthdatalist = [];
    this.income_year = 0;
    this.outcome_year = 0;
  }

  add_MonthDataList(int b, int c){
    monthdatalist.add(MonthDataStructure(b,c));
  }

  create_monthDataList(int year){
    monthdatalist.clear();
    this.income_year = 0;
    this.outcome_year = 0;
    for(int i = 0 ; i<12; i++){
      add_MonthDataList(0, 0);
    }

    for(int i=0; i<12; i++) {
      month_readList(year.toString()+'-'+(i+1).toString().padLeft(2,'0'), i);
    }
  }
  create_monthDataList_byTag(int year, String tag){
    monthdatalist.clear();
    for(int i = 0 ; i<12; i++){
      add_MonthDataList(0, 0);
    }

    for(int i=0; i<12; i++) {
      month_readList_byTag(year.toString()+'-'+(i+1).toString().padLeft(2,'0'), i, tag);
    }
  }

  month_readList(String fn, int index){
    _filename = fn;
    File file = File('${staticfunction.appDocumentsDirectory.path}/DataSource/$_filename.txt');

    if(!file.existsSync()) return;
    String fileContent = file.readAsStringSync();
    if(fileContent.isEmpty) return;

    for(int i=0; i<fileContent.split('\n').length-1;i++) {
      String inputStream;
      String amount, clr;

      inputStream = fileContent.split('\n')[i];
      amount = inputStream.split('#')[1];
      clr = inputStream.split('#')[4];

      if(clr == 'green') {
        monthdatalist[index].add_value(int.parse(amount));
        income_year += int.parse(amount);
      }
      else {
        monthdatalist[index].sub_value(int.parse(amount));
        outcome_year += int.parse(amount);
      }
    }
  }

  month_readList_byTag(String fn, int index, String tag){
    _filename = fn;
    File file = File('${staticfunction.appDocumentsDirectory.path}/DataSource/$_filename.txt');

    if(!file.existsSync()){return;}
    String fileContent = file.readAsStringSync();
    if(fileContent.isEmpty) {return;}

    for(int i=0; i<fileContent.split('\n').length-1;i++) {
      String inputStream;
      String amount, founded, clr;

      inputStream = fileContent.split('\n')[i];
      amount = inputStream.split('#')[1];
      founded = inputStream.split('#')[2];
      clr = inputStream.split('#')[4];

      if(tag == founded) {
        if (clr == 'green') monthdatalist[index].add_value(int.parse(amount));
        else monthdatalist[index].sub_value(int.parse(amount));
      }
    }
  }

  int get_income_year(){
    return income_year;
  }

  int get_outcome_year(){
    return outcome_year;
  }
}