import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_homework/I8n/jstomp.dart';
import 'package:hello_homework/pages/contacts/friends/add_friend_message.dart';
import 'home_content.dart';
import 'home_drawer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:hello_homework/common/Global.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageBody();
}

class HomePageBody extends State<HomePage> {
  String userNickName = Global.username;
  String avatar = Global.avater;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //进行初始化操作：
    print("开始进行初始化操作！");

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AddFriendsMsg()));
            },
            icon: Icon(Icons.wc),
          )
        ],
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyDrawer()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: Global.avater==""?DecorationImage(
                  image: AssetImage("assets/images/work.png"),
                  fit: BoxFit.cover,
                ):DecorationImage(
                  image: NetworkImage(Global.avater),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          userNickName,
        ),
      ),
      body: MyHomeContent(),
    );
  }
}
