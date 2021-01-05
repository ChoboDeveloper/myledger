import 'package:flutter/material.dart';
import 'package:myledger/month_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Month_chart extends StatefulWidget {
  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month_chart> {
  List<charts.Series> seriesList;

  @override
  void initState() {
    super.initState();
    seriesList = _createData();
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }

  List<charts.Series<Stat, String>> _createData() {
    final Month_Data = [
      Stat('1', 25),
      Stat('2', 30),
    ];

    return [
      charts.Series<Stat, String>(
        id: 'Stat',
        domainFn: (Stat stats, _) => stats.month,
        measureFn: (Stat stats, _) => stats.amount,
        data: Month_Data,
        fillColorFn: (Stat Stats, _) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hi'),
      ),
      body: Container(
        child: barChart(),
      ),
    );
  }
}

class Stat {
  final String month;
  final int amount;

  Stat(this.month, this.amount);
}