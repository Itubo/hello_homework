import 'package:flutter/material.dart';
import '../contacts/contacts.dart';
import '../chat/chat_main.dart';
import '../contacts/main.dart';
import '../home/home.dart';
import '../personal/personal.dart';
import '../personal/to_personal.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IndexState();
}

class _IndexState extends State<IndexPage> {
  int current_index = 0;

  final List<Widget> _children = [HomePage(),MyApp(), Personal(),];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(143, 148, 251, 1),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(size: 30),
        selectedItemColor: Color.fromRGBO(143, 148, 251, 1),
        currentIndex: current_index,
        type: BottomNavigationBarType.fixed,
        items: ItemList.list,
        onTap: (index) {
          if (this.current_index != index) {
            setState(() {
              this.current_index = index;
            });
          }
        },
      ),
      // body: IndexedStack(
      //   index: current_index,
      //   children: [
      //     HomePage(),
      //     MyApp(),
      //     Personal(),
      //   ],
      // ),
      body: _children[current_index],
    );
  }
}

class ItemList {
  static List<BottomNavigationBarItem> list = [
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.home),
      label: "首页",
      activeIcon: Icon(Icons.home_work),
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.green,
      icon: Icon(Icons.message),
      label: "联系人",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.lightBlue,
      icon: Icon(Icons.people),
      label: "个人中心",
    ),
  ];
}
