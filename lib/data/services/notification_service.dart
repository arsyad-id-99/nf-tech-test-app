import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nf_tech_test_app/main.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'Notifikasi Penting NF', // title
    description:
        'Channel ini digunakan untuk notifikasi penting pendaftaran siswa.',
    importance: Importance.max,
  );

  Future<void> initNotification() async {
    await _fcm.requestPermission();

    String? token = await _fcm.getToken();
    debugPrint("FCM Token: $token");

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("Notifikasi lokal diklik: ${details.payload}");
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    _initPushNotification();
  }

  void _initPushNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: message.data['nisn'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: android.smallIcon,
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigation(message);
    });

    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) _handleNavigation(message);
    });
  }

  void _handleNavigation(RemoteMessage message) {
    final String? nisn = message.data['nisn'];

    if (nisn != null) {
      navigatorKey.currentState?.pushNamed('/detail', arguments: nisn);
    }
  }
}
