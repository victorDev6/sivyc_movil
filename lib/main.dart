import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sivyc/providers/Usuario.dart';
import 'package:sivyc/screens/home.dart';
import 'package:sivyc/screens/login.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'High_importance_channel',
  'High Importance Notifications',
  //'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  runApp(Login());
}

class Login extends StatelessWidget {

  SharedPreferences? sharedPreferences;

  Future<String?> verificarSesion() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences!.getString('correo') == null) {
      return '';
    }
    return sharedPreferences!.getString('name');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Usuarios())
      ],
      child: MaterialApp(
        title: 'Login',
        theme: ThemeData(
          primaryColor: const Color(0xFF541533),
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        home: FutureBuilder(
            future: verificarSesion(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data != '') {
                    return Home();
                  }
                  return LoginPage();
                }
                else {
                  return LoginPage();
                }
              }
              return Container(child: Center(child: CircularProgressIndicator(color: Color(0xFF541533),)));
            },
            //child: Home()
        )
      ),
    );
  }
}

