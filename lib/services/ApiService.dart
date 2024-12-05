import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      return json.decode(response.data); // Trả về token
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    }
  }

  // Hàm lấy danh sách khách hàng
  Future<List<dynamic>> getCustomers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://sale.crmviet.vn:8180/crm/api/v1/customers'),
        headers: {'Authorization': 'Bearer $token',
             'Content-Type':'application/json'},
      );
      
      final result = jsonDecode(response.body);
      
      return result['customers'].map((e) => Map<String, dynamic>.from(e)).toList();// Trả về danh sách khách hàng
    } on DioException catch (e) {
      throw Exception('Failed to fetch customers: ${e.response?.data ?? e.message}');
    }
  }
}
