// ignore_for_file: prefer_const_constructors, unused_import, avoid_print, unused_local_variable
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/onboarding/onboarding.dart';
import 'package:singlegrocery/pages/cart/cartpage.dart';
import 'package:singlegrocery/pages/splash.dart';
import 'package:singlegrocery/theme/MyThemes.dart';
import 'package:singlegrocery/theme/ThemeModel.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/pages/Home/homepage.dart';
import 'package:singlegrocery/translation/codegen_loader.g.dart';
import 'package:sizer/sizer.dart';

int? initscreen;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // 'This channel is used for important notifications.', //// description
  importance: Importance.defaultImportance,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  initscreen = prefs.getInt(init_Screen);
  cartcount count = Get.put(cartcount());
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(
        Brightness.light,
      ),
      child: Consumer(
        builder: (context, ThemeModel thememodel, child) {
          return EasyLocalization(
            path: 'translation',
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            fallbackLocale: Locale('en'),
            assetLoader: CodegenLoader(),
            child: Sizer(
              builder: (context, orientation, deviceType) {
                return Phoenix(
                  child: GetMaterialApp(
                    scrollBehavior: MyBehavior(),
                    supportedLocales: context.supportedLocales,
                    localizationsDelegates: context.localizationDelegates,
                    locale: context.locale,
                    debugShowCheckedModeBanner: false,
                    theme: thememodel.isdark
                        ? MyThemes.DarkTheme
                        : MyThemes.LightTheme,
                    home: initscreen == 0 || initscreen == null
                        ? OnBoarding()
                        : splash(),
                  ),
                );
              },
            ),
          );
        },
      ),
    ),
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}




//   commmands for generate localization string file 
//   flutter pub run easy_localization:generate -S "translation" -O "lib/translation"       
//   flutter pub run easy_localization:generate -S "translation" -O "lib/translation"       
//   flutter pub run easy_localization:generate -S "translation" -O "lib/translation" -o "locale_keys.g.dart" -f keys
