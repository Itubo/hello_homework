import 'dart:convert';
import 'package:hello_homework/generated/json/base/json_field.dart';
import 'package:hello_homework/generated/json/login_po_jo_entity.g.dart';

@JsonSerializable()
class LoginPoJoEntity {

	late bool flag;
	late String message;
	dynamic data;
  
  LoginPoJoEntity();

  factory LoginPoJoEntity.fromJson(Map<String, dynamic> json) => $LoginPoJoEntityFromJson(json);

  Map<String, dynamic> toJson() => $LoginPoJoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}