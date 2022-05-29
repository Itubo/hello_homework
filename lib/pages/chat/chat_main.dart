import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_homework/common/Global.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class MyChat extends StatefulWidget {
  String Fname = "";
  int fid = 1;

  MyChat(this.fid, {Key? key}) : super(key: key);
  // MyChat(this.Fname, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyChat();
}

class _MyChat extends State<MyChat> {
  StompClient? stompClient;

  String fname = "";
  String nickname = Global.username;

  TextEditingController? textEditingController;
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  List<ItemData> newData = [
    // ItemData(
    //     123,
    //     "wang",
    //     "明天上午实验室开会记得来实验室,明天上午实验室开会记得来实验室,明天上午实验室开会记得来实验室,明天上午实验室开会记得来实验室",
    //     "2022",
    //     "http://m.imeitou.com/uploads/allimg/220329/5-220329102945.jpg"),
    // ItemData(123, "shen", "好的", "2022",
    //     "http://m.imeitou.com/uploads/allimg/220329/5-220329102945.jpg"),
    // ItemData(
    //     123,
    //     "shen",
    //     "具体时间呢?可以给我说嘛,具体时间呢?可以给我说嘛,具体时间呢?可以给我说嘛,具体时间呢?可以给我说嘛",
    //     "2022",
    //     "http://m.imeitou.com/uploads/allimg/220329/5-220329102945.jpg"),
    // ItemData(123, "wang", "上午9.计算机大楼门口", "2022",
    //     "http://m.imeitou.com/uploads/allimg/220329/5-220329102945.jpg"),
    // ItemData(123, "shen", "好的", "2022",
    //     "http://m.imeitou.com/uploads/allimg/220329/5-220329102945.jpg"),
  ];
  List<ItemData> loadMoreData = [];

  var centerKey = GlobalKey();
  var scroller = ScrollController();
  double extentAfter = 0;

  void getFame() async{
    Dio dio = Dio();
    // var dataInfo = {'fid':widget.fid};
    var chat = {'fid':widget.fid};
    print(Global.baseURL+'/getFname');
    Response  response = await dio.post(Global.baseURL+'/getFname',data: chat);
    setState(() {
      widget.Fname = response.toString();
    });
    // print('这是第一个 返回的是 fname');
    // print(response);
  }

  void getHistory() async {
    Dio dio = Dio();
    // var dataInfo = {'fid':widget.fid,'uid':Global.uid};
    var chat = {'fid':widget.fid,'uid':Global.uid};
    Response response = await dio.post(Global.baseURL+'/getHistory',data:chat);
    print("这是第二个 返回的是 history");
    // List<ItemData> list = response as List<ItemData>;
    // newData = list;
    // print(newData);
    print(response);
    List<dynamic> list = json.decode(response.toString());
    print(list);
    for(var i=0;i<list.length;i++) {
      if(list[i]['msg'].toString()!=" " && list[i]['username']!=null) {
        ItemData itemData = ItemData(list[i]['uid'], list[i]['username'].toString(), list[i]['msg'].toString(), 2022.toString(), list[i]['avatar'].toString());
        loadMoreData.insert(0, itemData);
      }
    }
    setState(() {
      newData = loadMoreData;
    });
  }

  void afterconnect(StompFrame frame) {
    print("我已经连接成功！");
    stompClient?.subscribe(
        destination: '/topic/user/' + widget.fid.toString() + '/' + Global.uid.toString() + '/singleChat',
        callback: (frame) {
          print("聊天界面 订阅成功！");
              Map<String,dynamic> list;
              list = json.decode(frame.body!);
              ItemData it = ItemData(list['uid'], list['username'].toString(),
                  list['msg'].toString(), list['time'].toString(), list['avatar'].toString());
              // print(json.decode(frame.body!));
              // print("上边是list");
              // ItemData id = ItemData(list?[0]['uid'], list?[0]['username'].toString()??"",
              //     list?[0]['msg'].toString()??"", list?[0]["time"].toString()??"", list?[0]['avatar'].toString()??"");
              // setState(() {
              //   newData.insert(0,id);
              // });
              // print(list);
              if(list['msg'].toString()!=" "&&list['msg']!=null) {
                print("111111111111");
                setState(() {
                  newData.insert(0, it);
                });
              }
        }
    );
    stompClient?.send(
      destination: "/app/singleChat",
      body: json.encode({'uid': Global.uid,'fid': widget.fid,'message': " "}),

    );
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    // initData();
    //发送第一个post
    getFame();
    //第二个post
    getHistory();
    //订阅
    stompClient = StompClient(
      config: StompConfig(
        url: Global.baseWS + '/classChat',
        onConnect: afterconnect,
        beforeConnect: () async {
          print("聊天页面！");
          print('waiting to connect...');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient?.activate();
  }


  @override
  void dispose() {
    // 销毁时,申请 quitSingleChat
    Dio dio = Dio();
    var chat = {'fid':widget.fid,'uid':Global.uid};
    dio.post(Global.baseURL+"/quitSingleChat",data: chat);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        toolbarHeight: 50,
        title: Text(widget.Fname),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context," ");
          },
        ),
      ),
      backgroundColor: const Color.fromRGBO(233, 236, 239, 1),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF1F5FB),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                //列表内容少的时候靠上
                alignment: Alignment.topCenter,
                child: _renderList(),
              ),
            ),
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                      constraints: const BoxConstraints(
                        maxHeight: 100.0,
                        minHeight: 30.0,
                      ),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF5F6FF),
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      child: TextField(
                        controller: textEditingController,
                        cursorColor: const Color(0xFF464EB5),
                        maxLines: null,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 0.0, bottom: 10),
                          hintText: "回复",
                          hintStyle:
                          TextStyle(color: Color(0xFFADB3BA), fontSize: 15),
                        ),
                        style:
                        const TextStyle(color: Color(0xFF03073C), fontSize: 15),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      alignment: Alignment.center,
                      height: 70,
                      child: const Text(
                        '发送',
                        style: TextStyle(
                          color: Color(0xFF464EB5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    //在这里处理点击发送事件
                    onTap: () {
                      sendTxt();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendTxt() async {
    if (textEditingController?.value.text.trim() == " ") {
      return;
    }
    String? message = textEditingController?.value.text;
    textEditingController?.text = "";
    var chat = {'uid': Global.uid,'fid': widget.fid,'message': message};
    print(chat);
    print("上面是聊天消息");
    stompClient?.send(
      destination: "/app/singleChat",
      body: json.encode({'uid': Global.uid,'fid': widget.fid,'message': message}),
    );
    print("我发送消息了！");
    setState(() {
      // addMessage(chat);
    });
  }

  addMessage(message) {
    DateTime today = new DateTime.now();
    String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    ItemData id = ItemData(Global.uid, Global.username, message, dateSlug, "");
    newData.insert(0,id);
    Future.delayed(Duration(seconds: 1),() {
        _scrollController.jumpTo(0);
    });
  }

  //渲染对话列表
  _renderList() {
    return GestureDetector(
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 27),
        itemBuilder: (context, index) {
          var item = newData[index];
          return GestureDetector(
            //此处用于判断，渲染哪一个
            child: item.uid == Global.uid
                ? _renderRowSendByMe(context, item)
                : _renderRowSendByOthers(context, item),
            onTap: () {},
          );
        },
        itemCount: newData.length,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget _renderRowSendByOthers(BuildContext context, ItemData item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: <Widget>[
          Padding(
            child: Text(
              // CommonUtils.timeStampFormat(item['createdAt']),
              item.time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFA1A6BB),
                fontSize: 14,
              ),
            ),
            padding: const EdgeInsets.only(bottom: 10),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 45),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      color: Color(0xFF464EB5),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    child: Text(
                      item.username.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 1),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text(
                          item.username,
                          softWrap: true,
                          style: const TextStyle(
                            color: Color(0xFF677092),
                            fontSize: 14,
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 20, right: 30),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(4.0, 7.0),
                                    color: Color(0x04000000),
                                    blurRadius: 10,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            margin: const EdgeInsets.only(top: 8, left: 10),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              item.msg,
                              style: const TextStyle(
                                color: Color(0xFF03073C),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderRowSendByMe(BuildContext context, ItemData item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: <Widget>[
          Padding(
            child: Text(
              item.time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFA1A6BB),
                fontSize: 14,
              ),
            ),
            padding: const EdgeInsets.only(bottom: 20),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: Color(0xFF464EB5),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  child: Text(
                    item.username.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 1),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    child: Text(
                      item.username,
                      softWrap: true,
                      style: const TextStyle(
                        color: Color(0xFF677092),
                        fontSize: 14,
                      ),
                    ),
                    padding: const EdgeInsets.only(right: 20),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          ConstrainedBox(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, right: 8),
                              decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(4.0, 7.0),
                                      color: Color(0x04000000),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  color: Colors.lightBlueAccent,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                item.msg,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            constraints: const BoxConstraints(
                              maxWidth: 305,
                            ),
                          ),
                          // Container(
                          //     margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
                          //     child: item['status'] == SENDING_TYPE
                          //         ? ConstrainedBox(
                          //       constraints:
                          //       BoxConstraints(maxWidth: 10, maxHeight: 10),
                          //       child: Container(
                          //         width: 10,
                          //         height: 10,
                          //         child: CircularProgressIndicator(
                          //           strokeWidth: 2.0,
                          //           valueColor: new AlwaysStoppedAnimation<Color>(
                          //               Colors.grey),
                          //         ),
                          //       ),
                          //     )
                          //         : item['status'] == FAILED_TYPE
                          //         ? Image(
                          //         width: 11,
                          //         height: 20,
                          //         image: AssetImage(
                          //             "static/images/network_error_icon.png"))
                          //         : Container()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ItemData {
  int uid;
  String username;
  String msg;
  String time;
  String avatar;

  ItemData(this.uid, this.username, this.msg, this.time, this.avatar);
}
