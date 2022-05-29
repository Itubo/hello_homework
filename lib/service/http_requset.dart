import 'package:dio/dio.dart';

import 'config.dart';

//进行网络封装
class MyRequest {
  static final BaseOptions baseOptions = BaseOptions(
      baseUrl: HttpConfig.baseURL, connectTimeout: HttpConfig.timeout);
  static final Dio dio = Dio(baseOptions);

  static Future<T> request<T>(String url,
      {String method = "get", Map<String,
          dynamic>? params, Interceptor? interc}) async {
    //1.创建单独请求。
    final options = Options(method: method);


    Interceptor dInter = InterceptorsWrapper(
      onRequest: (options,handler) {
        print("请求拦截器");
        return handler.next(options);
      },
      onResponse: (res,handler) {
        print("响应拦截器");
        return handler.next(res);
      },
      onError: (e,handler) {
        print("错误拦截器");
        return handler.next(e);
      }
    );
    //2.发送网络请求。
    try {
    Response response =
    await dio.request(url, queryParameters: params, options: options);
    return response.data;
    } on DioError catch (e) {
    return Future.error(e);
    }
  }
}
