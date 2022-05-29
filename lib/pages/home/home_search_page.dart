import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../../common/Global.dart';
import '../personal/personal_show_info.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}




class _SearchPageState extends State<SearchPage> {

  static List<dynamic> list = [];

  addPeople(people) {
    print(people);
    list.removeRange(0, list.length);
    if(people==null) {
      setState(() {
        list.removeRange(0, list.length);
      });
      return;
    };
    setState(() {
      list.insert(0, people);
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBar(callback: (people) => addPeople(people)),
          Expanded(
            flex: 1,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: itemBuilder,
                itemCount: list.length,
                itemExtent: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        print(list[index]);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShowInfo(uid: list[index].uid,isF: list[index].flag!=0,)));
      },
      child: ListTile(
        title: Text(list[index].username.toString()),
        subtitle: Text(list[index].name??"暂无"),
        trailing: MaterialButton(
          shape: RoundedRectangleBorder(side: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text("加好友",style: TextStyle(color: Colors.white),),
          color: Colors.blue,
          onPressed: list[index].flag==0?() {
            print("这个有效果");
            print(list[index].uid);
            print(Global.uid);
            _SearchBarState.stompClient?.send(
              destination: "/app/requestFriends",
              body: json.encode({'uid': Global.uid,'fid': list[index].uid}),
            );
            print("我点过了！");
          }:null,
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: NetworkImage(list[index].avatar.toString()),
                // image: AssetImage('assets/images/work.png'),
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final callback;
  const SearchBar({Key? key,this.callback}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  static StompClient? stompClient;

  TextEditingController _textEditingController = TextEditingController();
  bool _showClean = false;



  getPerson(text) async{
    Dio dio = Dio();
    if(text=="")  {
      widget.callback(null);
      return;
    }
    var userDetail = {'username': text,'uid': Global.uid};
    Response response = await dio.post(Global.baseURL + '/findUser',data: userDetail);
    print(response);
    print("上面是我请求到的people数据！");
    var data = json.decode(response.toString());
    AddPeople addPeople = AddPeople(username: data['username'],uid: data['uid'],avatar: data['avatar'],name: data['name'],flag: data['flag']);
    widget.callback(addPeople);
  }

  void onConnect(StompFrame frame) {
    print("jiahaoyou我开始订阅！");
    stompClient?.subscribe(
      destination: "/topic/user/"+ Global.uid.toString() +"/requestFriends",
      callback: (frame) {
        print("添加好友订阅成功");
        print(frame.body!);
      },
    );
    print("我发送数据了");
  }

  @override
  void initState() {
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
    return Container(
      height: 84,
      color: Colors.blue,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            height: 44,
            child: Row(
              children: [
                Container(
                  width: 370,
                  height: 34,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(Icons.search,color: Colors.grey,), //放大镜
                      IconButton(
                          onPressed: () {
                            print("我点击了！");
                            print(_textEditingController.text);
                            //点击搜索 首先 搜索用户！
                              //请求：
                            getPerson(_textEditingController.text);

                          },
                          icon: Icon(Icons.search,color: Colors.grey,)
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          onChanged: _onchange,
                          cursorColor: Colors.green,
                          autofocus: true,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 5, bottom: 10),
                            border: InputBorder.none,
                            hintText: '搜索',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      if (this._showClean)
                        GestureDetector(
                          child: Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _textEditingController.clear();
                            setState(() {
                              this._onchange("");
                            });
                          },
                        ),
                    ],
                  ),
                ), //圆角背景

                GestureDetector(
                  child: Text('取消'),
                  onTap: () {
                    _SearchPageState.list.removeRange(0,  _SearchPageState.list.length);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _onchange(String value) {
    if (value.length > 0) {
      setState(() {
        this._showClean = true;
      });
    } else {
      setState(() {
        this._showClean = false;
      });
    }
  }


}


class AddPeople {
  int? uid;
  String? username;
  String? avatar;
  int? flag;
  String? name;

  AddPeople({this.uid, this.username, this.avatar, this.flag,this.name});

}
