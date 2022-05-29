

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalChanging extends StatefulWidget {

  String url= "";
  String info = "";
  String data = "";

  PersonalChanging(this.url, this.info,this.data);

  @override
  State<StatefulWidget> createState() => _PersonalChanging();
}

class _PersonalChanging extends State<PersonalChanging> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.text = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("修改${widget.info}"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                print("我点击这个可以保存");
                Navigator.of(context).pop(textEditingController.text);
              },
              icon: Icon(Icons.save)
          )
        ],
      ),
      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.amberAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              height: 80,
              // color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: textEditingController,
                  autofocus: true,
                  maxLength: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}