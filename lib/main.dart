import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pressfame_new/Screens/splashscreen.dart';
import 'package:pressfame_new/constant/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

const iOSLocalizedLabels = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SharedPreferences.getInstance().then(
    (prefs) async {
      runApp(
        GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Snapta",
          theme: new ThemeData(
              accentColor: Colors.black,
              primaryColor: Colors.black,
              primaryColorDark: Colors.black),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            APP_SCREEN: (BuildContext context) => new App(prefs),
          },
        ),
      );
    },
  );
}
