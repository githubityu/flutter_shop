import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

//获取首页主题内容


Future getHomePageContent() {
  return request('homePageContent',
      formData: {'lon': '115.02932', 'lat': '35.76189'}, type: 1);
}

/// url 请求地址
/// formData 请求参数
/// type 请求方式
/// 0 get 1 post 默认0
Future request(String url, {formData, int type = 0}) async {
  try {
    Response response;
    Dio dio = Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    final url2 = servicePath[url];
    print("获取数据$url2");
    if (formData == null) {
      switch (type) {
        case 0:
          response = await dio.get(url2);
          break;
        case 1:
          response = await dio.post(url2);
          break;
      }
    } else {
      if (type == 0) {
        response = await dio.get(url2, queryParameters: formData);
      } else {
        response = await dio.post(url2, data: formData);
      }
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("服务器异常");
    }
  } catch (e) {
    return print('====${e}');
  }
}
