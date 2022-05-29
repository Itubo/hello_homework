/**
 * 这个类主要是定义全局常量
 * 用于全局共享
 * 成员每个都是静态的。
 */
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';


class Global {
  static int uid = 1;                 // 用户的uid 用于唯一标识用户。
  static String baseURL = "http://c21fd2c.cpolar.cn";
  static String baseWS = "ws://c21fd2c.cpolar.cn";
  static String username = "shen";
  static String email = "";
  static String avater = "";

}