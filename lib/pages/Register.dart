import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello_homework/common/Global.dart';
import '../utils/urlUtils.dart';
import 'dart:convert' as convert;
import '../utils/login_po_jo_entity.dart';



class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String url = Global.baseURL+"/user/register";
  String username="";
  String email = "";
  String password1 = "";
  String password2 = "";
  String code = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwd1Controller = TextEditingController();
  final TextEditingController _pwd2Controller = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  FocusNode _namefocusNode = FocusNode();
  bool write = true;

  /**
   * 点击注册后传送所有的数据到后端
   */
  Future<void> _postData() async {
    print("发送注册");
    Dio dio = new Dio();
    var user = {"username":username,"password":password1,"email":email};
    Response response = await dio.post(url,data: user);
    /**
     * 解析JSON
     */
    Map<String,dynamic> emailMap = convert.json.decode(response.toString());
    var logname = LoginPoJoEntity.fromJson(emailMap);
    if(logname.flag){
      print("注册成功");//用户名不存在，继续操作
      Fluttertoast.showToast(msg: "注册成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context)
          .pushNamed('/login');
    }else{
      print("注册失败");
      Fluttertoast.showToast(msg: logname.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  /**
   * 验证用户名是否存在
   */
  Future<void> _postusername() async {
    print("发送姓名");
    username = _nameController.text;
    Dio dio = new Dio();
    var uname = {"username":username,"email":email,"verifyCode":code};
    Response response = await dio.post(url,data: uname);
    print("nameresponse:");
    print(response);
    /**
     * 解析JSON
     */
    Map<String,dynamic> emailMap = convert.json.decode(response.toString());
    var logname = new LoginPoJoEntity.fromJson(emailMap);
    if(logname.flag){
      print("用户名不存在"); //用户名不存在，继续操作
      write = true;
      setState(() {
      });
    }else{
      print("用户名存在");

      Fluttertoast.showToast(msg: logname.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      write = false;
      setState(() {

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _namefocusNode.addListener((){
        username = _nameController.text;
        if (!_namefocusNode.hasFocus) {
         print('name失去焦点');
         _postusername();
        }else{
         print('name得到焦点');
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        title: Text("用户注册"),
      ),
      body:
      Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/regbg.png"),
          ),
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.white, width: 1),
                    color: Color.fromRGBO(255, 255, 255, .5),
                    borderRadius: new BorderRadius.circular(20.0)),
                child: Column(children: [
                  TextField(
                    // focusNode: _namefocusNode,
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
                    enabled: write,
                    controller: _pwd1Controller,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "密码",
                      hintText: "请输入密码",
                    ),
                    onChanged: (value) {
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    enabled: write,
                    controller: _pwd2Controller,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      labelText: "确认密码",
                      hintText: "请输入密码",
                    ),
                    onChanged: (value) {
                    },
                  ),
                  SizedBox(height: 20,),

                  TextField(
                    enabled: write,
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email_sharp),
                      labelText:"邮箱",
                      hintText: "请输入邮箱",
                    ),
                  ),
                  // TextField(
                  //   enabled: write,
                  //   controller: _codeController,
                  //   decoration: InputDecoration(
                  //     icon: Icon(Icons.alternate_email_sharp),
                  //     labelText:"验证码",
                  //     hintText: "请输入验证码",
                  //   ),
                  // ),

                  SizedBox(height: 20,),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      child: Text("注册", style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        username = _nameController.text;
                        password1 = _pwd1Controller.text;
                        password2 = _pwd2Controller.text;
                        email = _emailController.text;
                        code = _codeController.text;
                        if(password1==password2){
                          _postData();
                        }else{
                          Fluttertoast.showToast(msg: "两次密码不一致，请重新输入",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }


                      },
                      style: ButtonStyle(
                        // padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                        Text("已经有账号？"),
                        TextButton(
                          child: Text("立即登录"),
                          onPressed: () {
                            print("跳转到注册");
                            Navigator.of(context)
                                .pushReplacementNamed('/login');
                          },
                        ),
                        SizedBox(width: 70,),

                      ],
                    ),
                  )
                ]),
                ),
            )

          ],
        ),
      )



    );
  }
}
