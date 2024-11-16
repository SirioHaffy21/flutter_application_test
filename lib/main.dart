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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _deviceToken;

  @override
  void initState() {
    super.initState();
    _getDeviceToken();
  }

  void _getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    setState(() {
      _deviceToken = token;
    });
    print("Device Token: $token"); // In ra console
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("FCM Device Token")),
        body: Center(child: Text("Device Token: $_deviceToken")),
      ),
    );
  }
}
