import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/categories_screen.dart';
import 'services/firebase_service.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('BG message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "API_KEY",
      appId: "APP_ID",
      messagingSenderId: "SENDER_ID",
      projectId: "PROJECT_ID",
    ),
  );


  await FirebaseService.initFCM();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const CategoriesScreen(),
    );
  }
}
