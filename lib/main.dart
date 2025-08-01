import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/themes/app_themes.dart';
import 'core/views/dashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  NotificationController.initializeLocalNotifications();

  runApp(const ProviderScope(child: MyApp()));
}

class NotificationController {
  static NotificationChannel _buildChannel(
    String key,
    String name,
    String description, {
    bool playSound = true,
    bool onlyAlertOnce = true,
    DefaultRingtoneType? ringtoneType,
  }) {
    return NotificationChannel(
      channelKey: key,
      channelName: name,
      channelDescription: description,
      playSound: playSound,
      onlyAlertOnce: onlyAlertOnce,
      defaultRingtoneType: ringtoneType,
      groupAlertBehavior: GroupAlertBehavior.Children,
      importance: NotificationImportance.High,
      defaultPrivacy: NotificationPrivacy.Private,
    );
  }

  // Extraction de la configuration des canaux
  static List<NotificationChannel> get _channels => [
    _buildChannel('alerts', 'Alerts', 'Alert notification', playSound: true),
  ];

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null, //'resource://drawable/res_app_icon',//
      _channels,
      debug: false,
    );
    NotificationController().getPermissions();
    // Get initial notification action is optional
    // initialAction = await AwesomeNotifications()
    //     .getInitialNotificationAction(removeFromActionEvents: false);
  }

  getPermissions() async {
    await AwesomeNotifications().resetGlobalBadge();
    // firebaseNotif.requestPermission();
    await AwesomeNotifications().isNotificationAllowed().then((v) async {
      if (!v) {
        await AwesomeNotifications().requestPermissionToSendNotifications(
          permissions: [
            NotificationPermission.Alert,
            NotificationPermission.Sound,
            NotificationPermission.Badge,
            NotificationPermission.Vibration,
            NotificationPermission.Light,
            NotificationPermission.FullScreenIntent,
          ],
        );
      }
    });
  }

  static Future<void> showNotif({
    required String title,
    required String body,
    Map<String, String?> payload = const {},
    String channelKey = 'alerts',
  }) async {
    bool isallowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isallowed) {
      //no permission of local notification
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      //show notification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          //simgple notification
          id: DateTime.now().microsecondsSinceEpoch % 1000,
          channelKey: channelKey, //set configuration wuth key "basic"
          title: title,
          body: body,
          payload: payload,
          autoDismissible: true,
          locked: false,
          category: NotificationCategory.Message,
        ),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Repat Event',
          theme: AppThemes.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const DashScreen(),
        );
      },
    );
  }
}
