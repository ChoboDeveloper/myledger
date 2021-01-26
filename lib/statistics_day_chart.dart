import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'day_datalist.dart';
import 'staticfunction.dart';

class Day_chart extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day_chart> {
  DataList dl;
  String _current_year, _current_month;
  int div;
  bool flag = false;
  List<Stat> Daily_data = [];
  List<charts.Series> seriesList = [];
  List<Color> colorlist = [
    Colors.amber, Colors.purple, Colors.deepPurple, Colors.redAccent,
    Colors.orange, Colors.blueGrey, Colors.brown, Colors.lightGreen,
    Colors.grey, Colors.teal];

  @override
  void initState() {
    super.initState();
    dl = new DataList();

    dl.readList(staticfunction.getfilename(DateTime.now()));
    _current_year = DateTime.now().year.toString();
    _current_month = DateTime.now().month.toString().padLeft(2, '0');

    seriesList = _createSampleData();
  }

  pieChart() {
    return charts.PieChart(
      seriesList,
      animate: true,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 110,
        arcRendererDecorators: []
      ),
    );
  }

  List<charts.Series<Stat, String>> _createSampleData() {
    Daily_data = []; div = 0;
    for(int i=0; i<dl.datalist.length; i++){
      int index = Daily_data.indexWhere((element) => element.tag == dl.datalist[i].tag);
      if(index == -1){
        if(!flag && dl.datalist[i].clr == 'red')
          Daily_data.add(Stat(dl.datalist[i].tag, int.parse(dl.datalist[i].amount),colorlist[i%10]));
        else if(flag && dl.datalist[i].clr == 'green')
          Daily_data.add(Stat(dl.datalist[i].tag, int.parse(dl.datalist[i].amount),colorlist[i%10]));
        else
          continue;
      }
      else{
        Daily_data[index].amount += int.parse(dl.datalist[i].amount);
      }
      div += int.parse(dl.datalist[i].amount);
    }

    Daily_data.sort((b, a) => a.amount.compareTo(b.amount));
    return [
      new charts.Series<Stat, String>(
        id: 'Sales',
        domainFn: (Stat sales, _) => sales.tag,
        measureFn: (Stat sales, _) => sales.amount,
        colorFn: (Stat sales,_) => charts.ColorUtil.fromDartColor(sales.color),
        data: Daily_data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Stat row, _) => '${row.amount}%',
      )
    ];
  }

  void _getCurrentdate(String direction){
    if(direction == 'right'){
      if(_current_month == '12'){
        _current_year = (int.parse(_current_year)+1).toString();
        _current_month = '01';
      }
      else
        _current_month = (int.parse(_current_month)+1).toString().padLeft(2, '0');
    }
    else{
      if(_current_month == '01'){
        _current_year = (int.parse(_current_year)-1).toString();
        _current_month = '12';
      }
      else
        _current_month = (int.parse(_current_month)-1).toString().padLeft(2, '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(child:Row(children: [
                Container(
                  width: 50,
                  child: FlatButton(
                    child: Icon(Icons.chevron_left),
                    onPressed: (){print('left');
                    _getCurrentdate('left');
                    dl.datalist.clear();
                    dl.readList(staticfunction.getfilename(DateTime.parse('$_current_year-$_current_month-01')));
                    seriesList.clear();
                    seriesList = _createSampleData();
                    setState(() {});
                  },
                ),),
                Container(
                  margin: EdgeInsets.zero,
                  child: Text('$_current_year년 $_current_month월', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,)),
                ),
                Container(
                  width: 50,
                  child: FlatButton(
                    child: Icon(Icons.chevron_right),
                    onPressed: (){print('right');
                    _getCurrentdate('right');
                    dl.datalist.clear();
                    dl.readList(staticfunction.getfilename(DateTime.parse('$_current_year-$_current_month-01')));
                    seriesList.clear();
                    seriesList = _createSampleData();
                    setState(() {});
                  },
                ),),
                ],)),
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: Text(staticfunction.getcurrencyformatInt(div)+'원',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.grey[200],
            child: pieChart(),
          ),
          Container(
            height: 10,
          ),
          Container(
            height: screenHeight * 0.325,
            color: Colors.grey[200],
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: Daily_data.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  height: 50,
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(5.0),
                        child: Text((Daily_data[index].amount/div*100).toStringAsFixed(1)+'%',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        decoration: BoxDecoration(
                          color:Daily_data[index].color,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text(Daily_data[index].tag,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                          Text(staticfunction.getcurrencyformatInt(Daily_data[index].amount)+'원',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                        ],
                      ),
                    ),);
                },
              separatorBuilder: (context, index) {
                return const Divider(color: Colors.black54);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0,10.0,0,0),
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text('수입/지출 변경하기'),
              onPressed: (){
                if(flag) flag = false; else flag =true;
                seriesList.clear();
                seriesList = _createSampleData();
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
      ),
    );
  }
}

/// Sample linear data type.
class Stat {
  final String tag;
  int amount;
  final Color color;

  Stat(this.tag, this.amount, this.color);
}