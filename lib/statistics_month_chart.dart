import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myledger/month_datalist.dart';
import 'day_tagdatalist.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Month_chart extends StatefulWidget {
  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month_chart> {
  List<charts.Series> seriesList;
  TagList tl;
  MonthDataList ml;
  bool flag = false;
  int year = DateTime.now().year;
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    ml = new MonthDataList();
    tl = new TagList();

    // default : draw Annual outcome chart
    tl.readList('output');
    ml.create_monthDataList(year);
    seriesList = _createData(year, flag);
  }

  // Draw BarChart
  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }

  // Create Month Chart DataList
  List<charts.Series<Stat, String>> _createData(int year, bool flag) {
    List<Stat> Month_Data = [];

    if(flag) {
      for (int i = 0; i < ml.monthdatalist.length; i++)
        Month_Data.add(Stat((i + 1).toString() + '월', ml.monthdatalist[i].income));
    }
    else{
      for (int i = 0; i < ml.monthdatalist.length; i++)
        Month_Data.add(Stat((i + 1).toString() + '월', ml.monthdatalist[i].outcome));
    }

    return [
      charts.Series<Stat, String>(
        id: 'Stat',
        domainFn: (Stat stats, _) => stats.month,
        measureFn: (Stat stats, _) => stats.amount,
        data: Month_Data,
        fillColorFn: (Stat Stats, _) {
          return flag ? charts.MaterialPalette.green.shadeDefault : charts.MaterialPalette.red.shadeDefault;
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Button to last year
              FlatButton(
                child: Icon(Icons.chevron_left),
                onPressed: (){
                  print('left');
                  // if didn`t select Tag,
                  if(dropdownValue == null)
                    ml.create_monthDataList(--year);
                  // if Selected Tag, read Data by Tag
                  else
                    ml.create_monthDataList_byTag(--year, dropdownValue);
                  // Create Month Chart DataList
                  seriesList = _createData(year, flag);
                  setState(() {});
                },
              ),
              Text(year.toString()+'년', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,)),
              // Button to next year
              FlatButton(
                child: Icon(Icons.chevron_right),
                onPressed: (){
                  print('right');
                  if(dropdownValue == null)
                    ml.create_monthDataList(++year);
                  else
                    ml.create_monthDataList_byTag(++year, dropdownValue);
                  seriesList = _createData(year, flag);
                  setState(() {});
                },
              ),
              // Create Tag Menu
              Container(
                margin: EdgeInsets.only(left: 16.0),
                child: DropdownButton(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      // set Tag
                      dropdownValue = newValue;
                      print(dropdownValue);
                      ml.create_monthDataList_byTag(year, dropdownValue);
                      seriesList = _createData(year, flag);
                      setState(() {});
                    });
                  },
                  items: tl.taglist
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),),
              ),
            ],
          ),
        ),
        Container(
          height: 500,
          child: barChart(),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0,10.0,0,0),
          alignment: Alignment.centerRight,
          child: FlatButton(
            child: Text('수입/지출 변경하기'),
            onPressed: (){
              if(flag) flag = false; else flag =true;
              ml.create_monthDataList(year);
              dropdownValue = null;
              tl.taglist.clear();
              flag ? tl.readList('input') : tl.readList('output');
              seriesList = _createData(year, flag);
              setState(() {});
            },
            shape: RoundedRectangleBorder(side: BorderSide(
                color: Colors.black,
                width: 1.5,
                style: BorderStyle.solid
            ), borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ],
    );
  }
}

class Stat {
  final String month;
  final int amount;

  Stat(this.month, this.amount);
}