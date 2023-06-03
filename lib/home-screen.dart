import 'package:firebase_notifications/notification-services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationsServices notificationsServices=NotificationsServices();// making object of NotificationsServices class and calling in initState function
  void initState(){
    super.initState();
    notificationsServices.requestNotificationPermission();
    notificationsServices.firebaseInit(context);
   // notificationsServices.isTokenRefresh();//this function will not work bcz always getDviceToken() function calls first and you get new function, but you both functions have their own benefit
    notificationsServices.getDeviceToken().then((value)// use then bcz its been called from future function
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
    );
  }
}
