import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_homework/common/Global.dart';
import 'package:hello_homework/pages/main/main.dart';
import 'package:hello_homework/pages/personal/to_personal.dart';

import '../chat/chat_main.dart';
import '../contacts/friends/friends_page.dart';

class ShowInfo extends StatefulWidget {
  int? uid;
  bool? isF;

  ShowInfo({this.isF, this.uid});

  @override
  State<StatefulWidget> createState() => _ShowInfo();
}

class _ShowInfo extends State<ShowInfo> {
  String dec = "暂无个性签名";
  String name = "未知";
  String sex = "未知";
  String brith = "2021";
  String tel = ".......";
  String ava = "assets/images/work.png";
  String avatar = "";
  bool have = false;

  int fid = 0;

  //初始化属性
  getInfo() async {
    Dio dio = Dio();
    var UserDetail = {'uid': widget.uid};
    print("我准备发送的uid是${UserDetail}");
    Response response =
        await dio.post(Global.baseURL + '/getPInfo', data: UserDetail);
    print("这是数据之前！");
    print(response);
    var info = json.decode(response.toString());
    print(info);
    print(info['uid']);
    print("这是朋友详情页");
    setState(() {
      dec = info['psign'] ?? "暂无个性签名";
      name = info['username'] ?? "未知";
      sex = info['sex'] ?? "未知";
      brith = info['birthday'] ?? "2022";
      tel = info['number'] ?? "123456789";
      avatar = info['avatar'] ?? "http://116.205.137.0:81/avatar/defalut.jpg";
      fid = info['uid'] ?? widget.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.isF = true;
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                expandedHeight: 240,
                leading: IconButton(
                  icon: Icon(
                    Icons.chevron_left_outlined,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 20,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("删除好友"),
                              content: Text("确定删除好友吗？"),
                              actions: [
                                FlatButton(
                                  child: Text("取消"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("确定"),
                                  onPressed: () async {
                                    Dio dio = Dio();
                                    var friend = {'uid': Global.uid,'fid': fid};
                                    dio.post(Global.baseURL + '/deleFriend', data: friend);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IndexPage()),
                                        (route) => false);
                                  },
                                ),
                              ],
                            );
                          });

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ChatMain(
                      //               uid: fid,
                      //               isF: widget.isF,
                      //             )));
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 180,
                              color: Color.fromRGBO(143, 148, 251, 1),

                              // child: Image(
                              //   image: AssetImage("assets/images/work.png"),
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 80,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        height: 100,
                        width: 100,
                        left: 25,
                        bottom: 35,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                image: NetworkImage(avatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          width: 250,
                          height: 100,
                          left: 125,
                          bottom: 40,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 100,
                            width: 250,
                            // color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment(-1, 0),
                                  height: 40,
                                  // color: Colors.red,
                                  child: Text(
                                    name.toString(),
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment(-1, 0),
                                  height: 40,
                                  // color: Colors.red,
                                  child: Text(dec.toString()),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("姓名"),
                        SizedBox(
                          width: 50,
                        ),
                        Text(name),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_alt,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("性别"),
                        SizedBox(
                          width: 50,
                        ),
                        Text(sex),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("生日"),
                        SizedBox(
                          width: 50,
                        ),
                        Text(brith),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("电话"),
                        SizedBox(
                          width: 50,
                        ),
                        Text(tel),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            height: 100,
            width: 420,
            child: Container(
              alignment: Alignment.center,
              height: 100,
              // color: Colors.red,
              child: widget.isF == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          //去留言界面跳转
                          onPressed: () {
                            print("我点击了");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ToPersonal(fid,avatar)));
                          },
                          child: Text("去留言"),
                        ),
                        MaterialButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) {
                              return MyChat(fid);
                            }));
                          },
                          child: Text("发送消息"),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                          minWidth: 200,
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            print("我点击了加好友");
                            Fluttertoast.showToast(
                                msg: "发送请求",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          child: Text("加好友"),
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
