import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myledger/day_datalist.dart';
import 'package:myledger/staticfunction.dart';

class DialogView extends StatefulWidget {
  DialogView({this.arguments});
  DataStructure arguments;

  @override
  _DialogViewState createState() => _DialogViewState();
}

class _DialogViewState extends State<DialogView> {
  bool flag_in = false, flag_out = false;
  DateTime _getMonth;
  TimeOfDay _getTime;
  final _datecontroller = TextEditingController();
  final _tagcontroller = TextEditingController();
  final _subjectcontroller = TextEditingController();
  final _amountcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _datecontroller.text = staticfunction.getdateformat(widget.arguments.date);
    if(widget.arguments.clr != '') {
      _amountcontroller.text = widget.arguments.amount;
      _subjectcontroller.text = widget.arguments.subject;
      _tagcontroller.text = widget.arguments.tag;
      flag_in = widget.arguments.clr == 'green' ? true : false;
      flag_out = widget.arguments.clr == 'green' ? false : true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          SizedBox(height: 30),
          Container(
            child: ToggleButtons(
              children: <Widget>[
              Container(
                child: Text('수입', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                width: 150,
                alignment: Alignment.center,
              ),
                Container(
                  child: Text('지출', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                  width: 150,
                  alignment: Alignment.center,
                ),
            ],
              borderRadius: BorderRadius.circular(5),
              borderWidth: 0.1,
              borderColor: Colors.black,
              selectedBorderColor: Colors.black,
              fillColor: flag_in ? Colors.green[400] : Colors.red[400],
              selectedColor: Colors.white,
              onPressed: (int index){
                if (index == 0) {
                  flag_in = true; flag_out = false;
                } else {
                  flag_out = true; flag_in = false;
                }
                flag_in == true ? print('flag_in') : print('flag_out');
                setState(() {});
              },
              isSelected: [flag_in, flag_out],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('날짜', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                width: 300,
                margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: Row(
                  children: [
                    OutlineButton(onPressed: () async{
                      Future<DateTime> selectedDate = showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(_datecontroller.text),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2030),
                          builder: (BuildContext context, Widget child) {
                            return Theme( data: ThemeData.dark(), child: child,);
                          }
                      );
                      _getMonth = await selectedDate;
                      if(_getMonth != null)
                        _datecontroller.text = staticfunction.getdateformat(_getMonth).split(' ')[0] +
                            ' ' + _datecontroller.text.split(' ')[1];
                      setState(() {});
                    }, child: Text(
                      _datecontroller.text.split(' ')[0],
                      style: TextStyle(color: Colors.black87),
                    ),
                      borderSide: BorderSide(style: BorderStyle.solid, width: 0.8),
                    ),
                    Container(
                      width: 10,
                    ),
                    OutlineButton(onPressed: () async{
                      Future<TimeOfDay> selectedTime = showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.parse(_datecontroller.text)),
                        builder: (BuildContext context, Widget child) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: child,
                          );
                        },
                      );
                      _getTime = await selectedTime;
                      if(_getTime != null){
                        _datecontroller.text = _datecontroller.text.split(' ')[0] +
                            ' ' + _getTime.hour.toString().padLeft(2, '0') + ':' + _getTime.minute.toString().padLeft(2, '0') + ':00';
                        setState(() {});
                      }
                      },
                      child: Text(
                        staticfunction.getTimeformat(DateTime.parse(_datecontroller.text)),
                      style: TextStyle(color: Colors.black87),
                    ),
                      borderSide: BorderSide(style: BorderStyle.solid, width: 0.8),
                    )
                  ],
                ),
              ),
            ],
          ),// button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('분류', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                width: 300,
                margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: TextField(
                  controller: _tagcontroller,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width:2.0),),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('내용', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                width: 300,
                margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: TextField(
                  controller: _subjectcontroller,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width:2.0),),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('금액', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                width: 300,
                margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: TextField(
                  controller: _amountcontroller,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width:2.0),),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 5, 5),
                  width: 250,
                  decoration: BoxDecoration(color: Colors.green[400],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FlatButton(
                    child: Text('저장하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                    onPressed: (){
                      widget.arguments.date = DateTime.parse(_datecontroller.text);
                      widget.arguments.tag = _tagcontroller.text;
                      widget.arguments.subject = _subjectcontroller.text;
                      widget.arguments.amount = _amountcontroller.text;
                      if(!flag_in && !flag_out)
                        print('please input flag');
                      else
                        widget.arguments.clr = flag_in ? 'green' : 'red';
                      if(widget.arguments.amount != '') {
                        Navigator.pop(context, widget.arguments);
                      }
                      else
                        print('please input amount');
                      },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
                  width: 100,
                  decoration: BoxDecoration(color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FlatButton(
                    child: Text('취소하기', style: TextStyle(fontSize: 15)),
                    onPressed: (){
                      Navigator.pop(context, widget.arguments);
                      },
                  ),
                ),
              ],
            ),
          ),  // button
        ],
      ),
    );
  }
}