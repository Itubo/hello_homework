import 'package:flutter/material.dart';
import 'pages/contacts/friends/add_friend_message.dart';
import 'pages/contacts/friends/friends_page.dart';
import 'pages/home/home_search_page.dart';
import 'pages/main/main.dart';
import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'pages/Login.dart';
import 'pages/Register.dart';
import 'pages/Forget.dart';
import 'pages/personal/personal_show_info.dart';

void main() {
  runApp(MyApp());
  // stompClient.activate();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateMyPage();
}

class CreateMyPage extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(143, 148, 251, 1),
      ),
      debugShowCheckedModeBanner: true,
      home: LoginPage(),
      // home: ShowInfo(),
      // home: AddFriendsMsg(),
      // home: FriendsPage(),
      // home: SearchPage(),
      // home: IndexPage(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => IndexPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/forget': (context) => ForgetPage()
      },
    );
  }
}
