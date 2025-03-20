import 'dart:developer';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:finesse_frontend/firebase_options.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Notifications.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:finesse_frontend/Provider/sellprovider.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Provider/virement.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:finesse_frontend/Screens/SplashScreen/SplashScreen.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:finesse_frontend/deeplinks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Message reçu en arrière-plan : ${message.notification?.title}");
}

Future<void> initializeNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("Permission accordée !");
  } else {
    print("Permission refusée !");
  }
  String? token = await messaging.getAPNSToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final applinks = AppLinks();
  final sub = applinks.uriLinkStream.listen((uri) {
    log("URI : ${uri.toString()}");
    print("URI : ${uri.toString()}");
  },);
  await initializeNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SellProductProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => Profileprovider()),
        ChangeNotifierProvider(create: (_) => Stories()),
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => VirementProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      routes: {
        '/ProfileFinos' : (context)=>  ProfileMain(id: 0,)
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: themeProvider.isDarkMode
            ? ColorScheme.dark(primary: Color(0XFF1C1C1C))
            : ColorScheme.fromSeed(seedColor: Colors.white, brightness: Brightness.light),
        useMaterial3: true,
      ),
      home: DeepLinksListener(child: const SplashScreen()),
    );
  }
}
