import 'package:flutter/material.dart';
import 'package:myledger/views/chart_views/day_chart_view.dart';
import 'package:myledger/views/chart_views/month_chart_view.dart';

class Statistics extends StatefulWidget {

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> with TickerProviderStateMixin {
  TabController _StatisticsTabController;

  @override
  void initState() {
    super.initState();
    _StatisticsTabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _StatisticsTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          color: Colors.white10,
          child:TabBar(
            controller: _StatisticsTabController,
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            unselectedLabelColor: Colors.black54,
            isScrollable: false,
            tabs: <Widget>[
              Tab(
                text: "월별통계",
              ),
              Tab(
                text: "연도별통계",
              ),
            ],
          ),
        ),
        Container(
          height: screenHeight * 0.80,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _StatisticsTabController,
            children: <Widget>[
              Day_chart(),
              Month_chart(),
            ],
          ),
        )
      ],
    );
  }
}