import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// use FirebaseMessaging.onBackgroundMessage(messageHandler);
@pragma('vm:entry-point')
Future<void> messageHandler(RemoteMessage message) async {
  print("getting Message");
  showLocalNotification(message);
}

// call before runApp
void firebaseMessagingListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("getting Message");
    showLocalNotification(message);
  });
}

showLocalNotification(RemoteMessage message) {
  Message notificationMessage = Message.fromJson(message.data);
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        icon:'resource://drawable/homelogo',
          id: 10,
          channelKey: 'basic_channel',
          title: notificationMessage.title,
          body: notificationMessage.message,
          largeIcon: 'resource://drawable/homelogo',roundedLargeIcon: false,));
}

class Message {
  String? title;
  String? message;

  Message({this.title, this.message});

  Message.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
  }
}
