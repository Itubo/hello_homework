import 'package:flutter/material.dart';
import 'friends/friends_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,//去掉 debug 标记
      theme:ThemeData(
        primarySwatch: Colors.blue,//导航栏颜色
      ),
      home: const FriendsPage(),
    );
  }
}

