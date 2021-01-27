import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/ledger_views/ledger_view.dart';
import 'views/chart_views/chart_view.dart';
import 'utils/format_function.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myledger',
      home: Scaffold(
        body: Center(
          child: MyHomePage(),
        ),
      ),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
    ));
    return FutureBuilder<dynamic>(
        future: formatfunction.getFilepath(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: Material(
                color: Colors.white10,
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.teal,
                    labelColor: Colors.teal,
                    unselectedLabelColor: Colors.black54,
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.library_books_rounded),
                      ),
                      Tab(
                        icon: Icon(Icons.insert_chart_outlined),
                      ),
                      Tab(
                        icon: Icon(Icons.settings),
                      ),
                    ]),
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Ledger(),
                  Statistics(),
                  Center(
                    child: Text("Settings"),
                  ),
                ],
                controller: _tabController,
              ),
            );
          }
          else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}



