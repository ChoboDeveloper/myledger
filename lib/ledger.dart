import 'package:flutter/material.dart';
import 'package:myledger/day_view.dart';
import 'package:myledger/month_view.dart';

class Ledger extends StatefulWidget {

  @override
  _LedgerState createState() => _LedgerState();
}

class _LedgerState extends State<Ledger> with TickerProviderStateMixin {
  TabController _LedgerTabController;

  @override
  void initState() {
    super.initState();
    _LedgerTabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _LedgerTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      children: <Widget>[
        Material(
          color: Colors.white10,
          child: TabBar(
            controller: _LedgerTabController,
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            unselectedLabelColor: Colors.black54,
            isScrollable: false,
            tabs: <Widget>[
              Tab(
                text: '일일',
              ),
              Tab(
                text: "월별",
              ),
            ],
          ),
        ),
        Container(
          height: screenHeight * 0.80,
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _LedgerTabController,
            children: <Widget>[
              Container(
                child: Daily_view(),
              ),
              Container(
                child: Month_view(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

