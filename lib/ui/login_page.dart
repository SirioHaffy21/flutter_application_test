import 'package:flutter/material.dart';
import 'package:flutter_application_test/services/auth_login_service.dart';

class LoginPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthLoginService _authService = AuthLoginService();

  void _login() async {
    setState(() {
      _isLoading = true; // Hiển thị loading spinner
    });

    try {
      final response = await _authService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      //response.
      print(response.toString());

      if (response['messages'] == 'success') {
        // Đăng nhập thành công
        print('Token: ${response['token']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        // Điều hướng sang trang chính (HomePage)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Hiển thị lỗi nếu không thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    } catch (e) {
      // Hiển thị lỗi kết nối hoặc lỗi server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Tắt loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Ẩn password
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
