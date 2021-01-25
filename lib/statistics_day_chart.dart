import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Day_chart extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day_chart> {
  List<charts.Series> seriesList = [];

  @override
  void initState() {
    super.initState();
    seriesList = _createSampleData();
  }

  pieChart() {
    return charts.PieChart(
      seriesList,
      animate: true,
      defaultRenderer: new charts.ArcRendererConfig(
        arcRendererDecorators: [new charts.ArcLabelDecorator(
          outsideLabelStyleSpec: charts.TextStyleSpec(fontSize: 14),
          labelPosition: charts.ArcLabelPosition.outside,
        )]),
    );
  }

  List<charts.Series<Stat, String>> _createSampleData() {
    final datas = [
      new Stat('용돈', 50, Colors.redAccent),
      new Stat('상여금', 25, Colors.orange),
      new Stat('월급', 20, Colors.yellow),
      new Stat('부수입', 5, Colors.green),
      new Stat('용돈2', 50, Colors.blue),
      new Stat('상여금2', 25, Colors.deepPurple),
      new Stat('월급2', 20, Colors.purple),
      new Stat('부수입2', 5, Colors.amber),
    ];

    return [
      new charts.Series<Stat, String>(
        id: 'Sales',
        domainFn: (Stat sales, _) => sales.tag,
        measureFn: (Stat sales, _) => sales.amount,
        colorFn: (Stat sales,_) => charts.ColorUtil.fromDartColor(sales.color),
        data: datas,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Stat row, _) => '${row.tag}\n${row.amount}%',
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Container(
            width: 250,
            height: 250,
            child: pieChart(),
          ),
          Container(
            height: 200,
            color: Colors.redAccent,
          )
        ],
      ),
    );
  }
}

/// Sample linear data type.
class Stat {
  final String tag;
  final int amount;
  final Color color;

  Stat(this.tag, this.amount, this.color);
}