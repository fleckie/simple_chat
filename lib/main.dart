import 'package:flutter/material.dart';
import 'services/sharedPreferencesHelper.dart';
import 'screens/chatList/chatListScreen.dart';
import 'screens/authentication/authenticate.dart';
import 'services/push_notificiations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  PushNotificationsManager pushNotificationManager = PushNotificationsManager();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
    widget.pushNotificationManager.init();
  }

  getLoggedInState() async {
    await SharedPreferencesHelper.getLoginStatus().then((value){
      setState(() {
        userIsLoggedIn  = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Chat',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor:  Color(0xff1F1F1F),
      ),
      home: userIsLoggedIn != null ? userIsLoggedIn ? ChatListScreen(): Authenticate()
          : Container(
        child: Center(
          child: Authenticate(),
        )
      )
    );
  }
}
