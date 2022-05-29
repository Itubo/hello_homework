import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../../../common/Global.dart';
import 'friends_data.dart';

class AddFriendsMsg extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddFriendsMsg();
}

class _AddFriendsMsg extends State<AddFriendsMsg> {
  StompClient? stompClient;
  bool isFirst = true;
  List<Contact> myContactList = [];

  void onConnect(StompFrame frame) {
    print("我开始订阅！");
    stompClient?.subscribe(
      destination: "/topic/user/" + Global.uid.toString() + "/addFriend",
      callback: (frame) {
        if (isFirst) {
          isFirst = false;
          var list = json.decode(frame.body!);
          for (var item in list) {
            setState(() {
              myContactList.insert(
                  0,
                  Contact(item["username"], item["fid"], item["tag"],
                      img_url: item["avater"]));
            });
          }
        } else {}
        print("新朋友界面订阅成功");
        print(frame.body!);
      },
    );
    print("我订阅后发送一个数据了");
    stompClient?.send(
      destination: "/app/addFriend",
      body: json.encode({'uid': Global.uid, 'fid': 0}),
    );
  }

  // getNewFriends() async{
  //   Dio dio = Dio();
  //   var userDetail = {'uid':Global.uid};
  //   Response response = await dio.post(Global.baseURL + "/getAllRequest",data:userDetail);
  //   print(response);
  //   print("这是新家好友的i西南西");
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //初始化数据 发送请求：
    // getNewFriends();

    stompClient = StompClient(
      config: StompConfig(
        url: Global.baseWS + '/classChat',
        onConnect: onConnect,
        beforeConnect: () async {
          print('connecting..., please wait');
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
      appBar: AppBar(
        title: Text("新朋友"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: _MyContactList(),
    );
  }

  _MyContactList() {
    return GestureDetector(
      child: ListView.builder(
          itemCount: myContactList.length,
          itemBuilder: (context, index) {
            return ListTile(
                leading: Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      image: DecorationImage(
                        image: NetworkImage(myContactList[index].img_url),
                        fit: BoxFit.cover,
                      ),
                    )),
                // child: Padding(
                //   child: Text(
                //     myContactList[index].name.toString().substring(0, 1),
                //     textAlign: TextAlign.center,
                //     style: const TextStyle(
                //       color: Colors.white,
                //       fontSize: 14,
                //     ),
                //   ),
                //   padding: const EdgeInsets.only(bottom: 1),
                // ),
                title: Text(myContactList[index].name.toString()),
                subtitle: Text("此人来自于账号查找"),
                trailing: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: myContactList[index].tag == 1
                            ? Text("添加")
                            : myContactList[index].tag == 2
                                ? Text("已添加")
                                : Text("等待验证"),
                        onPressed: myContactList[index].tag == 1
                            ? () {
                                print("添加");
                                print("要添加的两个人：");
                                print(myContactList[index].fid);
                                print(Global.uid);
                                stompClient?.send(
                                  destination: "/app/addFriend",
                                  body: json.encode({
                                    'uid': Global.uid,
                                    'fid': myContactList[index].fid
                                  }),
                                );
                                setState(() {
                                  myContactList[index].tag = 2;
                                });
                              }
                            : null,
                      ),
                      SizedBox(
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              myContactList.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.cancel_outlined),
                        ),
                      ),
                    ],
                  ),
                ));
          }),
    );
  }
}

class Contact {
  var name;
  var img_url;
  var fid;
  var tag;

  Contact(this.name, this.fid, this.tag, {this.img_url});
}
