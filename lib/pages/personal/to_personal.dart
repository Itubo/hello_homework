import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hello_homework/pages/Login.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../../common/Global.dart';
import 'AlertWidget.dart';
import 'personal_data.dart';

class ToPersonal extends StatefulWidget {
  String avatar;
  int fid;
  ToPersonal(this.fid, this.avatar);
  @override
  State<StatefulWidget> createState() => _ToPersonal();
}

class _ToPersonal extends State<ToPersonal> {
  bool isFirst = true;
  List l = [];
  StompClient? stompClient;
  String newMes = "";

  addMes() {
    print("我开始发送请求！");
    stompClient?.send(
      destination: "/app/writeLMsg",
      body: json.encode({"lmsg": newMes,'uid': widget.fid}),
    );
  }

  void onConnect(StompFrame frame) {
    print("首页我开始订阅！");
    stompClient?.subscribe(
      destination: '/topic/user/'+widget.fid.toString()+'/getAllLMsg',
      callback: (frame) {
        l.removeRange(0, l.length);
        print("朋友的中心订阅成功");
        print(frame.body);
        // print("我订阅成功！");
        var res = json.decode(frame.body!);
        for(var i in res) {
          setState(() {
            l.insert(0, i['lmsg']);
          });
        }
      },
    );
    print("我发送数据了");
    if(isFirst){
      isFirst = false;
      stompClient?.send(
        destination: "/app/getAllLMsg",
        body: json.encode({'uid': widget.fid,}),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stompClient = StompClient(
      config: StompConfig(
        url: Global.baseWS + '/classChat',
        onConnect: onConnect,
        beforeConnect: () async {
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient?.activate();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            backgroundColor: Color.fromRGBO(143, 148, 251, 1),
            expandedHeight: 300,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text("个人中心"),
              // background: Image.asset("assets/images/work.png",fit: BoxFit.cover,),
              background: Stack(
                children: [
                  Container(
                    height: 400,
                    color: Color.fromRGBO(143, 148, 251, 1),
                  ),
                  Positioned(
                      height: 100,
                      width: 100,
                      top: 70,
                      left: 30,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: widget.avatar==""
                                  ?DecorationImage(
                                  image: AssetImage("assets/images/work.png"),
                                  fit: BoxFit.cover)
                                  :DecorationImage(
                                  image: NetworkImage(widget.avatar),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return index == 0
                    ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      l[index].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    // margin: EdgeInsets.symmetric(vertical: -10),
                    alignment: Alignment.center,
                    // color: Colors.teal[100 * (index % 9)],
                    // child: Text('grid item $index'),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256),
                          1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 5),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      l[index].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    // margin: EdgeInsets.symmetric(vertical: -10),
                    alignment: Alignment.center,
                    // color: Colors.teal[100 * (index % 9)],
                    // child: Text('grid item $index'),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256),
                          1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                );
                ;
              },
              childCount: l.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          String mes = "";
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return MyAlert((val) {
                  newMes = val;
                  addMes();
                }, "输入留言", "请输入留言");
              });
        },
      ),
    );
  }
}
