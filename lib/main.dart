import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_test/services/ApiService.dart';
import 'package:flutter_application_test/ui/login_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

// ignore: must_be_immutable
class _MyAppState extends State<MyApp> {
  final ApiService apiService = ApiService('http://sale.crmviet.vn:8180/crm/api/v1'); // Thay bằng URL API của bạn
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _deviceToken;
  String? _notifyTitle;
  String? _notifyContent;

  @override
  // ignore: override_on_non_overriding_member
  void initState() {
    super.initState();
    _initializeFCM();
    tz.initializeTimeZones();
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
      // Hiển thị thông báo tùy chỉnh trong app
      _notifyTitle = message.notification?.title;
      _notifyContent = message.notification?.title;
    });

    
  }

  Future<void> requestNotificationPermissions() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      // Xử lý khi thông báo đã kích hoạt ứng dụng
    }

    if (await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ==
        false) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }

  // Hàm khởi tạo
  // ignore: unused_element
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Hàm hiển thị thông báo
  // ignore: unused_element
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID của thông báo
      _notifyTitle, // Tiêu đề
      _notifyContent, // Nội dung
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)), // Gửi sau 10 giây
      platformChannelSpecifics,
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
           UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(apiService: apiService),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(title: Text("Device Token Example")),
  //       body: Center(
  //         child: Text(
  //           _deviceToken != null
  //               ? "Device Token:\n$_deviceToken"
  //               : "Loading Device Token...",
  //           textAlign: TextAlign.center,
  //         ),
  //         // child: ElevatedButton(
  //         //   onPressed: _showNotification, 
  //         //   child: const Text('Hiển thị thông báo')
  //         // )
  //       ),
  //     ),
  //   );
  // }
}

