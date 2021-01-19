import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myledger/day_taglist.dart';

class TagView extends StatefulWidget {
  TagView({this.arguments, this.arguments_flag});

  bool arguments_flag;
  String arguments;

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<TagView>{
  TagList _tl;
  final _tagcontroller = TextEditingController();

  @override
  void initState() {
    _tl = new TagList();
    if(widget.arguments_flag){
      _tl.filename = 'input'; _tl.readList(_tl.filename);}
    else{
      _tl.filename = 'output'; _tl.readList(_tl.filename);}
  }

  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      width: 300.0,
      child: ListView.separated(
        itemCount: _tl.taglist.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(_tl.taglist[index]),
            onTap: (){
              widget.arguments = _tl.taglist[index];
              Navigator.pop(context, widget.arguments);},
            onLongPress: (){
              _tagcontroller.text = _tl.taglist[index];
              showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('분류변경'),
                    content: TextField(
                      controller: _tagcontroller,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width:2.0),),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    actions: [
                      FlatButton(
                        child: Text('수정하기'),
                        onPressed: () {
                          _tl.taglist[index] = _tagcontroller.text;
                          setState(() {});
                          Navigator.pop(context, '미분류');
                          },
                      ),
                      FlatButton(
                        child: Text('취소하기'),
                        onPressed: () {Navigator.pop(context, '미분류');},
                      ),
                      FlatButton(
                        child: Text('삭제하기', style: TextStyle(color: Colors.red),),
                        onPressed: () {Navigator.pop(context, '미분류');},
                      ),
                    ],
                  ));
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(color: Colors.black54);
        },
      ),
    );
  }
}