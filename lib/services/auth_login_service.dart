import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthLoginService {
  final String baseUrl = 'http://sale.crmviet.vn:8180/crm/api/v1';

  Future<Map<String,dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: json.encode({'username':username, 'password':password}),
    );

    if(response.statusCode == 200){
      return json.decode(handleApiResponse(response.body));
    }else{
      throw Exception('Failed to login');
    }
  }
}

String handleApiResponse(String responseBody) {
  try {
    Map<String, dynamic> response = jsonDecode(responseBody);

    if (response['messages'] == 'success') {
      print("Login thành công!");
      return response.toString();
    } else {
      print("Login thất bại: ${response['message']}");
      return response.toString();
    }
  } catch (e) {
    print("Lỗi khi xử lý API: $e");
    throw Exception();
  }
}