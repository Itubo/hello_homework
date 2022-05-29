import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils{
  static void showToast(String message){
    //根据消息长度决定自动消失时间
    double multiplier = 0.5;
    double flag = message.length*0.06*0.5;
    //计算显示时间
    int timeInSecForIos = (multiplier*flag).round();
    //如果已显示，取消先有的
    Fluttertoast.cancel();
    //显示Toast
   Fluttertoast.showToast(msg: message,
       backgroundColor: Colors.black54,
     gravity: ToastGravity.CENTER,
     timeInSecForIosWeb: timeInSecForIos,
   );
  }
}