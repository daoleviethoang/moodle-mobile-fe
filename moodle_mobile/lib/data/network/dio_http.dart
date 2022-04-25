import 'package:dio/dio.dart';

class Http {
  BaseOptions baseOptions = BaseOptions(
      responseType: ResponseType.json,
      receiveTimeout: 60000,
      contentType: Headers.formUrlEncodedContentType);
  Dio client = Dio();
  Http() {
    client = Dio(baseOptions);
  }
}