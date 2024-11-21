import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  final Dio _dio;

  ApiService(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  // Hàm đăng nhập
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login', // API endpoint
        options: Options(
          headers:{'Content-Type': 'application/json'},
        ),
        data: {
          'username': username,
          'password': password,
        },
      );
      //print("login response: $response"); 
      //print(response.data);
      return json.decode(response.data); // Trả về token
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    }
  }

  // Hàm lấy danh sách khách hàng
  Future<List<dynamic>> getCustomers(String token) async {
    try {
      final response = await _dio.get(
        '/customers', // API endpoint
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':'application/json'
          }, // Gửi token
        ),
      );
      //print(jsonDecode(response.data).runtimeType);
      //List<dynamic> jsonList = jsonDecode(response.data);
      print(response.data['customers']);
      //print(jsonList.toList(growable: false));
      return response.data;//['customers']; // Trả về danh sách khách hàng
    } on DioException catch (e) {
      throw Exception('Failed to fetch customers: ${e.response?.data ?? e.message}');
    }
  }
}
