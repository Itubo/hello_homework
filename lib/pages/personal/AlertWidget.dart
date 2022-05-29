import 'package:flutter/cupertino.dart';

class MyAlert extends StatefulWidget {

  final callback;                   //回调函数
  final title;                      //标题
  final placeholder;                //占位

  MyAlert(this.callback, this.title, this.placeholder);

  @override
  State<StatefulWidget> createState() => _MyAlert();
}

class _MyAlert extends State<MyAlert> {
  String input = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Column(
        children: [
          CupertinoTextField(
            placeholder: widget.placeholder,
            onChanged: (value) {
              input = value;
            },
          )
        ],
      ),
      actions: [
        CupertinoDialogAction(
            child: Text("取消"),
          onPressed: () {
              Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text("确定"),
          onPressed: () {
            //调用回调函数，来进行 添加数据。
            widget.callback(input);
            Navigator.pop(context);
          },
        )
      ],
    );
  }


}