import 'dart:async';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Screens/HomeScreens/HomeScreen.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:finesse_frontend/deeplinks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  double progress = 0.0;
  final int durationInSeconds = 2;
  Timer? _progressTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    Provider.of<Products>(context,listen:false).getProducts();
    Provider.of<Products>(context,listen:false).getProductsart();
    Provider.of<Products>(context,listen:false).getProductsViewed();
    Provider.of<Stories>(context,listen:false).loadUserStoriesData();
  }

  /// Fonction pour initialiser l'application et vérifier le token et les paramètres
  Future<void> _initializeApp() async {
    String? accessToken = await storage.read(key: 'access_token');
    String? parametre = await storage.read(key: 'parametre');
    
    _navigationTimer = Timer(Duration(seconds: durationInSeconds), () {
      if (!mounted) return;
      if (accessToken != null && accessToken.isNotEmpty && Provider.of<AuthService>(context,listen:false).currentUser!=null ) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Navigation(onItemSelected: (int value) {},currentIndex: 0,)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    });

    _loadUserDataBasedOnParam(parametre);
  }

  void _loadUserDataBasedOnParam(String? parametre) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (parametre == "normal") {
        Provider.of<AuthService>(context, listen: false).loadUserData();
      } else {
        Provider.of<AuthService>(context, listen: false).loadUserGoogleData();
      }
    });
  }

 

  @override
  void dispose() {
    // Annuler les timers pour éviter les appels après suppression
    _progressTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0XFF323232),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeIn(
                duration: Duration(milliseconds: 4000),
                child: Image.asset(
                  "assets/images/logosplash.png",
                  height: 500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}