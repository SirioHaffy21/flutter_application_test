import 'package:flutter/material.dart';
import 'package:flutter_application_test/services/ApiService.dart';
import 'package:flutter_application_test/utils/genMd5.dart';
import 'customer_list_page.dart';

class LoginPage extends StatefulWidget {
  final ApiService apiService;

  // ignore: use_super_parameters
  const LoginPage({Key? key, required this.apiService}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      // Gọi API đăng nhập
      final response = (await widget.apiService.login(
        _usernameController.text.trim(),
        genMd5(_passwordController.text.trim()),
      ));
      

      // Chuyển sang màn hình danh sách khách hàng
      if(response['messages'] == 'success'){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CustomerListPage(apiService: widget.apiService, token: response['token']),
                //HomePage(token: response['token']),
          ),
        );
      }else{
        throw Exception('Failed to login');
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
