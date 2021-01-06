import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myledger/staticfunction.dart';
import 'package:myledger/month_datalist.dart';

class Month_view extends StatefulWidget {
  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<Month_view> {
  MonthDataList ml;
  int year;

  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    ml = new MonthDataList();
    ml.init_monthDataList(year);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 37,
              child: Column(
                children: [
                  Text('수입', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(staticfunction.getcurrencyformatInt(ml.get_income_year())+'원', style: TextStyle(color: Colors.green[400],fontWeight: FontWeight.bold, fontSize: 14))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('지출', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(staticfunction.getcurrencyformatInt(ml.get_outcome_year())+'원', style: TextStyle(color: Colors.red[300],fontWeight: FontWeight.bold, fontSize: 14))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('합계', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(staticfunction.getcurrencyformatInt((ml.get_income_year()-ml.get_outcome_year()))+'원', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold, fontSize: 14))
                ],
              ),
            ),
          ],
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Icon(Icons.chevron_left),
                onPressed: (){
                  print('left');
                  ml.init_monthDataList(--year);
                  setState(() {});
                },
              ),
              Text(year.toString()+'년', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,)),
              FlatButton(
                child: Icon(Icons.chevron_right),
                onPressed: (){
                  print('right');
                  ml.init_monthDataList(++year);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < 12; i++)
                Container(
                  margin: EdgeInsets.all(2.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300], width:1.0)
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        margin: EdgeInsets.only(left: 15),
                        child:  Text((i+1).toString()+'월', style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold)),),
                      Container(
                        width: 120,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(staticfunction.getcurrencyformat(ml.monthdatalist[i].get_income())+'원', style: TextStyle(fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[400])),),
                      Container(
                        width: 100,
                        child: Text(staticfunction.getcurrencyformat(ml.monthdatalist[i].get_outcome())+'원', style: TextStyle(fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300])),),
                    ],
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}

