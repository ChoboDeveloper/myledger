import 'package:flutter/material.dart';
import 'dart:io';

class Month_view extends StatefulWidget {
  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<Month_view> {
  File file;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<int> month = [01,02,03,04,05,06,07,08,09,10,11,12];
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
                  Text('500원', style: TextStyle(color: Colors.green[400],fontWeight: FontWeight.bold, fontSize: 14))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('지출', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('400원', style: TextStyle(color: Colors.red[300],fontWeight: FontWeight.bold, fontSize: 14))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('합계', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('100원', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold, fontSize: 14))
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
                onPressed: (){print('left');
                },
              ),
              Text('2021년', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,)),
              FlatButton(
                child: Icon(Icons.chevron_right),
                onPressed: (){print('right');
                },
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for ( var i in month)
                Container(
                  margin: EdgeInsets.all(2.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey[300]),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(' '+ i.toString()+'월', style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold,)),
                      Text((i*1000).toString()+'원', style: TextStyle(fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[400])),
                      Text((i*500).toString()+'원', style: TextStyle(fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300])),
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
