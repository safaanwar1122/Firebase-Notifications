import 'dart:convert';

import 'package:firebase_notifications/notification-services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationsServices notificationsServices =
      NotificationsServices(); // making object of NotificationsServices class and calling in initState function
  void initState() {
    super.initState();
    notificationsServices.requestNotificationPermission();
    notificationsServices.firebaseInit(context);
    notificationsServices.setInteractMessage(context);
    // notificationsServices.isTokenRefresh();//this function will not work bcz always getDviceToken() function calls first and you get new function, but you both functions have their own benefit
    notificationsServices
        .getDeviceToken()
        .then((value) // use then bcz its been called from future function
            {
      print('Device token');
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Notifications playlist'),
        centerTitle: true,
      ),

      body: Center(
        child: TextButton(onPressed: () {
          notificationsServices.getDeviceToken().then((value) async{
            var data={
              'to':value.toString(),//to whom sending notification, if sending notifications from android to ios then paste ios device link here
              'priority':'high',
              'notification':{
                'title':'Safa',
                'body':'Subscribe to my channel',
              },
              'data':{
                'type':'msg',
                'id':'Safa',
              },
            };
            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body:jsonEncode(data) ,
              headers: {
              'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':'key=AAAAT1ttOwc:APA91bFcck8EWEIpvYWPfo9V9ASp-fHpV15waxCcw-4dW6B7M_fFpP112RTo7uQr_YKwShZoRXVoVivQ3Ct7S88bYzEwA2CdtLwe9owSiZCu3-ZLW_LeqOX06Cmem6ovo7A5HGdnNjtx',
              }
            );
          });
        },
          child: Text('Send Notifications'),
        ),

      ),
    );
  }
}
