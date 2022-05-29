import 'dart:convert' as convert;

import 'package:hello_homework/common/Global.dart';
import 'package:hello_homework/pages/main/main.dart';

import '../utils/toast_utils.dart';
import '../utils/urlUtils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/urlUtils.dart';
import '../utils/login_po_jo_entity.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  String username = "";
  String password = "";
  String url = Global.baseURL + "/user/login";

  @override
  void initState() {
    super.initState();
  }

  void _getData(String username, String password) async {
    /**
     *判断从后端得到的flag是true还是false，true跳转，false弹出用户名密码错误
     */
    // var boo = false;
    // if(boo){
    //   print("true");
    //   Navigator.of(context)
    //     .pushReplacementNamed('/forget');
    // }else{
    //   print("false");
    //   Fluttertoast.showToast(msg: "用户名密码错误",
    //   toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.grey,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    //   );
    // }

    /**
     * 测试正确
     */
    Dio dio = new Dio();
    var user = {"username": username, "password": password};
    Response response = await dio.post(url, data: user);

    /**
     * JSON解析测试
     */
    Map<String, dynamic> userMap = convert.json.decode(response.toString());
    var log = new LoginPoJoEntity.fromJson(userMap);
    print(log);
    //给全局变量添加值
    Global.uid = log.data['uid'];
    Global.username = log.data['username'];
    Global.avater = log.data['avatar'];

    if (log.flag) {
      //当用户名密码正确时，跳转，这里先跳转到注册页面测试
      // Navigator.of(context).pushReplacementNamed('/home');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => IndexPage()), (route) => false);
    } else {
      print("false");
      Fluttertoast.showToast(
          msg: log.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
            decoration: BoxDecoration(
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/bg.png"),
              ),
            ),
            child: ListView(children: [
              Padding(
                // padding: EdgeInsets.only(
                //     bottom: MediaQuery.of(context).viewInsets.bottom
                // ),
                padding: EdgeInsets.fromLTRB(30.0, 425.0, 30.0, 0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.white, width: 1),
                      color: Color.fromRGBO(255, 255, 255, .5),
                      borderRadius: new BorderRadius.circular(20.0)),
                  child: Column(children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_box_rounded),
                        labelText: '用户名',
                        hintText: "请输入用户名",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _pwdController,
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: "密码",
                        hintText: "请输入密码",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      child: ElevatedButton(
                        child: Text("登录", style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          username = _nameController.text;
                          password = _pwdController.text;
                          // Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => route == null);
                          _getData(username, password);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(143, 148, 251, 1)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: Row(
                        children: [
                          Text("没有账号？"),
                          TextButton(
                            child: Text("立即注册"),
                            onPressed: () {
                              print("跳转到注册");
                              Navigator.of(context)
                                  .pushNamed('/register');
                            },
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          TextButton(
                            child: Text("忘记密码"),
                            onPressed: () {
                              print("忘记密码");
                              Navigator.of(context)
                                  .pushNamed('/forget');
                            },
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              )
            ])));
  }
}
