import 'package:dio/dio.dart';

class GeneralService {
  // ignore: unused_field
  final Dio dio = Dio(BaseOptions(
    baseUrl: "http://sale.crmviet.vn:8180/crm/api/v1",
    headers: {'Content-Type': 'application/json'},
  ));
}