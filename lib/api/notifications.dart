import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi
{
  final message = FirebaseMessaging.instance;

  Future<void> initNotifications()async
  {
     await message.requestPermission();
     final fcmToken = await message.getToken();
     print(fcmToken);
     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    // Handle background messages here
  }
}