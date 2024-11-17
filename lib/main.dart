import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _deviceToken;

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  void _initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Lấy Device Token
    String? token = await messaging.getToken();
    setState(() {
      _deviceToken = token;
    });

    // In ra token (hoặc gửi token lên server)
    print("Device Token: $_deviceToken");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Device Token Example")),
        body: Center(
          child: Text(
            _deviceToken != null
                ? "Device Token:\n$_deviceToken"
                : "Loading Device Token...",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
