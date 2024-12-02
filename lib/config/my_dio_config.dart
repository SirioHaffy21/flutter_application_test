import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class MyDioConfig {
  static Dio getDio() {
    final dio = Dio();

    dio.httpClientAdapter = IOHttpClientAdapter()
    // ignore: deprecated_member_use
    ..onHttpClientCreate = (HttpClient client){
      client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return dio;
  }
}