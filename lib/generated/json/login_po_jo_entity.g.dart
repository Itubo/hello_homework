import 'package:hello_homework/generated/json/base/json_convert_content.dart';
import 'package:hello_homework/utils/login_po_jo_entity.dart';

LoginPoJoEntity $LoginPoJoEntityFromJson(Map<String, dynamic> json) {
	final LoginPoJoEntity loginPoJoEntity = LoginPoJoEntity();
	final bool? flag = jsonConvert.convert<bool>(json['flag']);
	if (flag != null) {
		loginPoJoEntity.flag = flag;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		loginPoJoEntity.message = message;
	}
	final dynamic? data = jsonConvert.convert<dynamic>(json['data']);
	if (data != null) {
		loginPoJoEntity.data = data;
	}
	return loginPoJoEntity;
}

Map<String, dynamic> $LoginPoJoEntityToJson(LoginPoJoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['flag'] = entity.flag;
	data['message'] = entity.message;
	data['data'] = entity.data;
	return data;
}