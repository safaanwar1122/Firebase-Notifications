import 'dart:math';

import 'package:firebase_notifications/message-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsServices {
  FirebaseMessaging messaging = FirebaseMessaging
      .instance; // FirebaseMessaging initialize and get instance to acces properties

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // initialize it below using voi function
  void requestNotificationPermission() async {
    //requestNotificationPermission function can be used anywhere by calling
    // object in initState and
    NotificationSettings settings = await messaging.requestPermission(
      alert:
          true, // notifactions can be shown to user on device if false not shown
      announcement: true,
      badge: true, // on app Icons indicators shown 1,2,3
      carPlay: true,
      criticalAlert: true,
      provisional:
          true, // not access permissions at front end grant them but when user will get 1st time notifications user can turn ON/OFF notifications
      sound: true,
      // if condition is used to check either conditions are authorized
    );
    if (settings.authorizationStatus ==
        AuthorizationStatus.authorized) //for android permission
    {
      print('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) //for ios permission
    {
      print('user granted provisional  permission');
    } else {
      print('user denied permission');
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    // to show notification when App is running follow below procedure
    var androidInitializationSettings = const AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // logo of android App attach with notification
    var iosInitializationSettings =
        const DarwinInitializationSettings(); // logo of ios  App attach with notification
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void firebaseInit(BuildContext context) {
    // this function works when App is active mode
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title
            .toString()); //will show notification on terminal
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type']);
        print(message.data['id']);
      }
      initLocalNotifications(context, message);
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    //show notification by local plugin

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High importance Notifications',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging
        .getToken(); // firebase send notification on device token, this token can get expired
    return token!;
  }

  void isTokenRefresh() async {
    // check is  token can get expired
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MessageScreen(id: '',)));
    }
  }
}
