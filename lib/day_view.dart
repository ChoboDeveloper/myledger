import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myledger/day_datalist.dart';
import 'package:myledger/staticfunction.dart';
import 'package:myledger/day_dialogview.dart';

class Daily_view extends StatefulWidget {
  @override
  _DailyState createState() => _DailyState();
}

class _DailyState extends State<Daily_view> with TickerProviderStateMixin {
  TabController _DailyTabController;
  DataList _dl;
  String _current_year, _current_month;

  @override
  void initState() {
    super.initState();
    _DailyTabController = new TabController(length: 3, vsync: this);
    _dl = new DataList();
    _dl.readList(staticfunction.getfilename(DateTime.now()));
    _dl.getTotal();
    _current_year = DateTime.now().year.toString();
    _current_month = DateTime.now().month.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    super.dispose();
    _DailyTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Column(
                children: [
                  Text('수입', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(staticfunction.getcurrencyformatInt(_dl.total_in)+'원', style: TextStyle(color: Colors.green[400],fontWeight: FontWeight.bold, fontSize: 14))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('지출', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(staticfunction.getcurrencyformatInt(_dl.total_out)+'원',style: TextStyle(color: Colors.red[300],fontWeight: FontWeight.bold, fontSize: 14))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('합계', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(staticfunction.getcurrencyformatInt(_dl.total)+'원', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14))
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
                _savefile();
                _getCurrentdate('left');
                _dl = new DataList();
                _dl.readList(staticfunction.getfilename(DateTime.parse('$_current_year-$_current_month-01')));
                _dl.getTotal();
                },
              ),
              Text('$_current_year년 $_current_month월', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,)),
              FlatButton(
                child: Icon(Icons.chevron_right),
                onPressed: (){print('right');
                _savefile();
                _getCurrentdate('right');
                _dl = new DataList();
                _dl.readList(staticfunction.getfilename(DateTime.parse('$_current_year-$_current_month-01')));
                _dl.getTotal();
                },
              ),
            ],
          ),
        ),
        Container(
          width: screenWidth * 0.8,
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(border: Border.all(width:2)),
          child:FlatButton(
            child: Text(' + 새로운 거래내역을 추가하기', style:  TextStyle(fontSize: 20.0)),
            onPressed: () async{
              DataStructure _getdata = new DataStructure();
              // 다른 월의 페이지에서 입력받는 경우
              if(_getdata.date.month.toString().padLeft(2, '0') != _current_month || _getdata.date.year.toString() != _current_year){
                print(_current_year + _current_month);
                _getdata.date = DateTime.parse(_current_year+'-'+_current_month+'-01 00:00:00.000');
              }
              // default : 현재 동일한 월인 경우
              _getdata = await Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => DialogView(arguments: _getdata))
              );
              // 입력받은 데이터가 존재하는 경우
              if(_getdata.amount != '') {
                // 동월인 경우 같은 경우 현재 데이터 파일에 저장
                if(_getdata.date.month.toString().padLeft(2, '0') == _current_month && _getdata.date.year.toString() == _current_year) {
                  _dl.addList(_getdata.date, _getdata.amount, _getdata.tag,
                      _getdata.subject, _getdata.clr);
                  _savefile();
                }
                // 다른 경우 다른 데이터 파일에 저장
                else _dl.saveOtherList(staticfunction.getfilename(_getdata.date), _getdata);
              }
              refresh(_dl);
              _savefile();
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: Colors.black87,
                  ),
                  insets: EdgeInsets.only(
                      left: 10,
                      right: 0,
                      bottom: 4)),
              isScrollable: true,
              controller: _DailyTabController,
              labelColor: Colors.black87,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.grey,
              tabs: <Widget>[
                Tab(
                  text: "전체 내역",
                ),
                Tab(
                  text: "수입",
                ),
                Tab(
                  text: "지출",
                ),
              ],
            ),
            Container(
              height: screenHeight * 0.525,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _DailyTabController,
                children: <Widget>[
                  Container(
                    child: ListView(
                      children: _create_ListView_Total(),
                    ),
                  ),
                  Container(
                    child: ListView(
                      children: _create_ListView_In(),
                    ),
                  ),
                  Container(
                    child: ListView(
                      children: _create_ListView_Out(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _create_ListView_Total() {
    refresh(_dl);
    _savefile();
    return new List<Widget>.generate(_dl.datalist.length, (int index){
      String sign = _dl.datalist[index].clr == 'green' ? '+ ' : '- ';
      String money = staticfunction.getcurrencyformat(_dl.datalist[index].amount);
      return InkWell(
        onTap: () async{
          DataStructure _getdata = _dl.datalist[index-1];
          _getdata = await Navigator.push(context,
              CupertinoPageRoute(builder: (context) => DialogView(arguments: _getdata))
          );
          if(_getdata != null && _getdata.date.month.toString().padLeft(2,'0') != _current_month){
            _dl.saveOtherList(staticfunction.getfilename(_getdata.date), _getdata);
            _dl.datalist.removeAt(index-1);
          }
          refresh(_dl);
        },
        onLongPress: (){
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('삭제하기', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                  onPressed: () {
                    _dl.datalist.removeAt(index-1);
                    refresh(_dl);
                    setState(() {});
                    print((index-1).toString() + 'dismissed');
                    Navigator.pop(context);
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('취소하기', style: TextStyle(color: Colors.grey),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        },
        child: Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(staticfunction.getdateformat_withtime(_dl.datalist[index].date),
                      style: TextStyle(fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  Text(_dl.datalist[index].subject == '' ? _dl.datalist[index].tag : _dl.datalist[index].subject, style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('$sign$money원', style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: _dl.datalist[index++].clr == 'green' ? Colors.green[400] : Colors.red[400])),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _create_ListView_In() {
    return new List<Widget>.generate(_dl.datalist.length, (int index) {
      String sign = '+ ';
      String money = staticfunction.getcurrencyformat(_dl.datalist[index].amount);
      if(_dl.datalist[index].clr == 'red') {
        index++;
        return Container();
      }
      return Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.grey[300]),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(staticfunction.getdateformat_withtime(_dl.datalist[index].date),
                    style: TextStyle(fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                Text(_dl.datalist[index].subject == '' ? _dl.datalist[index].tag : _dl.datalist[index].subject, style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold)),
              ],
            ),
            Text('$sign$money원', style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: _dl.datalist[index++].clr == 'green' ? Colors.green[400] : Colors.red[400])
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _create_ListView_Out() {
    return new List<Widget>.generate(_dl.datalist.length, (int index) {
      String sign = '- ';
      String money = staticfunction.getcurrencyformat(_dl.datalist[index].amount);
      if(_dl.datalist[index].clr == 'green') {
        index++;
        return Container();
      }
      return Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.grey[300]),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(staticfunction.getdateformat_withtime(_dl.datalist[index].date),
                    style: TextStyle(fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                Text(_dl.datalist[index].subject == '' ? _dl.datalist[index].tag : _dl.datalist[index].subject, style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold)),
              ],
            ),
            Text('$sign$money원', style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: _dl.datalist[index++].clr == 'green' ? Colors.green[400] : Colors.red[400])),
          ],
        ),
      );
    });
  }

  void _savefile() {
    _dl.saveList('$_current_year-$_current_month');
    setState(() {});
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

  void refresh(DataList dl){
    dl.datalist.sort((a,b) => b.date.compareTo(a.date));
    dl.getTotal();
  }
}

