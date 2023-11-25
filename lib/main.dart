import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haveli/utils/LocaleString.dart';
import 'package:haveli/utils/app_colors.dart';
import 'package:haveli/view/screens/home.dart';
import 'package:haveli/view/screens/language_selector.dart';
import 'package:hive_flutter/adapters.dart';

import 'controller/NotificationService.dart';
import 'controller/languageController.dart';
import 'controller/notificationController.dart';
import 'controller/theme_controller.dart';
import 'firebase_options.dart';
import 'model/db/ProductAdapter.dart';
import 'model/db/ProductOrderAdapter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductOrderAdapter());
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  await loadCurrentLanguage();
  await updateThemeState();
  await FirebaseMessaging.instance.subscribeToTopic('all');
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  firebaseMessagingListener();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      print("allowed");
    }
  });

  AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
      NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
      NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
      NotificationController.onDismissActionReceivedMethod);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haveli',
      translations: LocaleString(),
      theme: AppColor.lightAppTheme,
      darkTheme: AppColor.darkAppTheme,
      home: FirebaseAuth.instance.currentUser!=null? const MyHomePage() :  const LanguageScreen(),
    );
  }
}