import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> initFCM() async {

    await _fcm.requestPermission(alert: true, badge: true, sound: true);


    final token = await _fcm.getToken();
    //print('FCM Token: $token');

    if (token != null) {
      await _db.collection('fcm_tokens').doc(token).set({
        'token': token,
        'platform': Platform.operatingSystem,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _showLocal(notification.title, notification.body);
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<void> _showLocal(String? title, String? body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'recipes_channel', 'Recipes',
      channelDescription: 'Recipe reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platform = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title ?? 'Recipe', body ?? '', platform);
  }

  // favorites helpers
  static Future<void> addFavorite(Map<String, dynamic> fav) async {
    await _db.collection('favorites').add({
      ...fav,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  static Future<void> showLocalNotification(String title, String body) async {
    await showLocalNotification(title, body);
  }

  static Stream<QuerySnapshot> favoritesStream() {
    return _db.collection('favorites').orderBy('createdAt', descending: true).snapshots();
  }
}
