import 'dart:convert';
import 'dart:ffi';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../chat/chat_main.dart';
import 'home_search_page.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:hello_homework/common/Global.dart';

class MyHomeContent extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyHomeContent();
}

class _MyHomeContent extends State<MyHomeContent> {
  StompClient? stompClient;
  int num = 0;
  List<dynamic> list = [];
  void onConnect(StompFrame frame) {
    print("首页我开始订阅！");
    stompClient?.subscribe(
      destination: '/topic/user/' + Global.uid.toString() + '/getLMsg',
      callback: (frame) {
        print("主页订阅成功");
        print(frame.body);
        setState(() {
          list = json.decode(frame.body!);
        });
        print(list);
        print(list[0]['uid']);
        // print("我订阅成功！");
      },
    );
    print("我发送数据了");
    stompClient?.send(
      destination: "/app/getLMsg",
      body: json.encode({'uid': Global.uid,}),
    );
  }


  ScrollController controller = ScrollController();
  bool isLoading = false;

  Init() {
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
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(() {
      // print(controller.offset);
    });
    Init();
  }

  Future<Null> onRefresh() async {
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
            // foregroundColor: Colors.grey,
            titleSpacing: 0,
            toolbarHeight: 40,
            title: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  height: 30,
                  width: double.infinity,
                  // color: Colors.red,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ), //白
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          Text(
                            '   搜索',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SearchPage()));
              },
            ),
            backgroundColor: Colors.blueGrey,
            pinned: false,
            centerTitle: false,
          ),
          SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  child: ListTile(
                    title: Text(list[index]['fusername'].toString()),
                    subtitle: Text(list[index]['msg'].toString()),
                    trailing: list[index]['num']!=0
                    ?Badge(
                      animationType: BadgeAnimationType.fade,
                      badgeContent: Text(
                        list[index]['num'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    :null,
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: NetworkImage(list[index]['favatar'].toString()),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  onTap: () {
                    print("fid=" );
                    print(list[index]['fid']);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => new MyChat(list[index]['fid']))).then((value) {
                      setState(() {
                        Init();
                      });
                    });
                    // builder: (BuildContext context) => new MyChat(list?[index]['fusername'].toString()??"默认")));
                  },
                );
              },
              childCount: list.length,
            ),
            itemExtent: 80,
          )
        ],
      ),
    );
  }
}
class ItemInfo {

}
