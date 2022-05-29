import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_homework/common/Global.dart';
import 'package:hello_homework/pages/personal/personal_data_change.dart';
import 'package:image_picker/image_picker.dart';
import 'cropImage_route.dart';

class MyData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyData();
}

class _MyData extends State<MyData> {
  String nickname = "这是昵称";
  String sex = "男";
  String birthday = "2003";
  String tel = "12345678";
  String dec = "";
  String name = "";

  void getPic() async {
    print("这里可以修改头像!");
    // final List<AssetEntity>? assets = await AssetPicker.pickAssets(context);
    chooseImage();
  }

  Future chooseImage() async {
    await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((image) => cropImage(File(image?.path ?? "")));
  }

  void cropImage(File originalImage) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CropImageRoute(originalImage))).then((value) {
      print("我是头像" + Global.avater);
      setState(() {
        Global.avater = Global.avater;
      });
    });
  }

  void getInfo() async {
    Dio dio = Dio();

    Response response = await dio.post(Global.baseURL + '/getPInfo',data: {'uid':Global.uid});
    print(response);
    var res = json.decode(response.toString());
    setState(() {
      nickname = res['username'];
      sex = res['sex']??"未知";
      birthday = res['birthday']??"2022";
      tel = res['tel']??"未知";
      name = res['name']??"未知";
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  dataChange() async {
    print("我修改数据了");
    Dio dio = Dio();
    dio.post(Global.baseURL + '/updatePInfo', data: {
      'uid': Global.uid,
      'username': nickname,
      'avatar': Global.avater,
      'birthday': birthday,
      'name': name,
      'number': tel
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("个人信息"),
        // leading: ,
      ),
      body: Container(
        color: Color.fromRGBO(219, 223, 224, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                    color: Colors.white,
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: getPic,
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    image: Global.avater == ""
                                        ? DecorationImage(
                                            image: AssetImage(
                                                "assets/images/work.png"),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: NetworkImage(Global.avater),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "修改头像",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(200, 200, 200, 1)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "昵称",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(180, 180, 180, 1)),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          width: 300,
                          // color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                nickname,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () {
                                  print("我点击了");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PersonalChanging(
                                                  "", "昵称", nickname)))
                                      .then((value) {

                                    setState(() {
                                      nickname = value;
                                    });
                                    dataChange();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(180, 180, 180, 1),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "生日",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(180, 180, 180, 1)),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          width: 300,
                          // color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                birthday,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () {
                                  print("我点击了");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PersonalChanging(
                                              "", "修改昵称", birthday)))
                                      .then((value) {
                                    setState(() {
                                      birthday = value;
                                    });
                                    dataChange();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(180, 180, 180, 1),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "姓名",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(180, 180, 180, 1)),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          width: 300,
                          // color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () {
                                  print("我点击了");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PersonalChanging(
                                              "", name.toString(), name)))
                                      .then((value) {
                                    setState(() {
                                      name = value;
                                    });
                                    dataChange();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(180, 180, 180, 1),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "性别",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(180, 180, 180, 1)),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          width: 300,
                          // color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sex,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () {
                                  print("我点击了");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PersonalChanging(
                                              "", sex.toString(), sex)))
                                      .then((value) {
                                    setState(() {
                                      sex = value;
                                    });
                                    dataChange();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(180, 180, 180, 1),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "电话",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(180, 180, 180, 1)),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          width: 300,
                          // color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tel,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () {
                                  print("我点击了");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PersonalChanging(
                                              "", tel.toString(), tel)))
                                      .then((value) {
                                    setState(() {
                                      tel = value;
                                    });
                                    dataChange();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(180, 180, 180, 1),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "个签",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(180, 180, 180, 1)),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          width: 300,
                          // color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dec,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () {
                                  print("我点击了");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PersonalChanging(
                                              "", dec.toString(), dec)))
                                      .then((value) {
                                    setState(() {
                                      dec = value;
                                    });
                                    dataChange();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(180, 180, 180, 1),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
