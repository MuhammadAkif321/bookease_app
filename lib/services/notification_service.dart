import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
  _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    // Get FCM token
    String? token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
  }

  static Future<void> _showLocalNotification(
      RemoteMessage message,
      ) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'bookease_channel',
      'BookEase Notifications',
      channelDescription: 'Booking notifications',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF6C63FF),
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      message.notification?.title ?? 'BookEase',
      message.notification?.body ?? 'You have a notification',
      details,
    );
  }

  // Show local booking confirmation notification
  static Future<void> showBookingConfirmation({
    required String providerName,
    required String date,
    required String time,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'bookease_channel',
      'BookEase Notifications',
      channelDescription: 'Booking notifications',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF6C63FF),
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      1,
      '✅ Booking Confirmed!',
      'Appointment with $providerName on $date at $time',
      details,
    );
  }

  // Show reminder notification
  static Future<void> showReminder({
    required String providerName,
    required String time,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'bookease_channel',
      'BookEase Notifications',
      channelDescription: 'Booking notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      2,
      '🔔 Appointment Reminder!',
      'Your appointment with $providerName is at $time today',
      details,
    );
  }
}