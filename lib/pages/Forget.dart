
import 'package:hello_homework/common/Global.dart';

import '../utils/urlUtils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/login_po_jo_entity.dart';

class ForgetPage extends StatefulWidget {
  ForgetPage({Key? key}) : super(key: key);

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  bool write = true;
  bool emailwrite = true;
  String urlname = Global.baseURL+"/user/send"; //判断用户是否存在,邮箱是否正确
  String urlpwd = Global.baseURL+"/user/modifyPwd";//修改密码
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
  FocusNode _emailfocusNode = FocusNode();
  FocusNode _codefocusNode = FocusNode();

  /**
   * 点点确定后触发的修改密码事件
   */
  void _forgetData() async {
      print("点击确定发送修改后的密码");
      username = _nameController.text;
      email = _emailController.text;
      code = _codeController.text;
      password1 = _pwd1Controller.text;
      password2 = _pwd2Controller.text;

      print("验证码："+code);
      print("密码："+password1);
      Dio dio = new Dio();
      var user = {"username":username,"email":email,"verifyCode":code,"password":password1};
      Response response = await dio.post(urlpwd,data:user);
      print("response:");
      print(response);
      /**
       * 解析JSON
       */
      Map<String,dynamic> emailMap = convert.json.decode(response.toString());
      var logemailname = new LoginPoJoEntity.fromJson(emailMap);
      if(logemailname.flag){
        print("修改成功");
        Fluttertoast.showToast(msg: logemailname.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.of(context)
            .pushNamed('/login');
      }else{
        print("验证码错误");
        Fluttertoast.showToast(msg: logemailname.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        write = true;
        emailwrite = true;
        setState(() {

        });
      }
      // print("修改成功");


  }
/**
 * 发送邮箱和用户名
 */
  Future<void> _postemailname() async {
    username = _nameController.text;
    email = _emailController.text;
    Dio dio = new Dio();
    var uname = {"username":username,"email":email};
    print("postemail");
    Response response = await dio.post(urlname,data: uname);
    print("emailnameresponse:");
    print(response);
    /**
     * 解析JSON
     */
    Map<String,dynamic> emailMap = convert.json.decode(response.toString());
    var logemailname = new LoginPoJoEntity.fromJson(emailMap);
    if(logemailname.flag){
      print("邮箱和用户名正确");
      Fluttertoast.showToast(msg: logemailname.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      write = true;
      emailwrite = true;
      setState(() {

      });
    }else{
      print("邮箱或用户名错误");
      Fluttertoast.showToast(msg: logemailname.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      write = false;
      emailwrite = false;
      setState(() {

      });
    }
  }

  /**
   * 发送给后端验证验证码，目前先不用，再输完密码后一块判断
   */
  Future<void> _postcode() async {
    username = _nameController.text;
    email = _emailController.text;
    code = _codeController.text;
    print("验证码：");
    print(code);
    Dio dio = new Dio();
    var uname = {"username":username,"email":email,"verifyCode":code};
    Response response = await dio.post(urlpwd,data: uname);
    print("coderesponse:");
    print(response);
    /**
     * 解析JSON
     */
    Map<String,dynamic> emailMap = convert.json.decode(response.toString());
    var logemailname = new LoginPoJoEntity.fromJson(emailMap);
    if(logemailname.flag){
      print("验证码正确");
      write = true;
      emailwrite = true;
      setState(() {

      });
    }else{
      print("验证码错误");
      Fluttertoast.showToast(msg: logemailname.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      write = false;
      emailwrite = true;
      setState(() {

      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _namefocusNode.addListener((){
    //   username = _nameController.text;
    //   if (!_namefocusNode.hasFocus) {
    //    print('name失去焦点');
    //    _postusername();
    //   }else{
    //    print('name得到焦点');
    //   }
    // });
    _emailfocusNode.addListener((){
      if (!_emailfocusNode.hasFocus) {
        print('email失去焦点');
        _postemailname();
      }else{
        print('email得到焦点');
      }
    });

    _codefocusNode.addListener(() {
      if(!_codefocusNode.hasFocus){
        print('验证码失去焦点');
        _postcode();
      }else{
        print('验证码获得焦点');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          title: Text("忘记密码"),
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
                      focusNode: _namefocusNode,
                      controller: _nameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_box_rounded),
                        labelText: '用户名',
                        hintText: "请输入用户名",
                      ),
                    ),
                    TextField(
                      focusNode: _emailfocusNode,
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.alternate_email_sharp),
                        labelText:"邮箱",
                        hintText: "请输入邮箱",
                      ),
                    ),

                    TextField(
                      // focusNode: _codefocusNode,
                      enabled: emailwrite,
                      controller: _codeController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.alternate_email_sharp),
                        labelText:"验证码",
                        hintText: "请输入验证码",
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
                    SizedBox(height: 20,),
                    Container(
                      width: 300,
                      child: ElevatedButton(
                        child: Text("确定", style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          username = _nameController.text;
                          email = _emailController.text;
                          code = _codeController.text;
                          password1 = _pwd1Controller.text;
                          password2 = _pwd2Controller.text;
                          if(password1==password2){
                            print("两次密码一致");
                            _forgetData();
                          }else{
                            Fluttertoast.showToast(msg: "两次密码不一致，请重新输入",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            write = false;
                            emailwrite = false;
                            setState(() {

                            });
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
                          TextButton(
                            child: Text("立即登录"),
                            onPressed: () {
                              print("跳转到登录");
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

//2695852470@qq.com

