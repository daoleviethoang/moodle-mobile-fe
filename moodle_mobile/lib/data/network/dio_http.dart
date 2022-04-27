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
<<<<<<< HEAD
}
=======
}
>>>>>>> e487a2d27d20b795ccd9571d22ba3b9418d1ddc5
