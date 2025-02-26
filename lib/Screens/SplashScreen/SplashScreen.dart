import 'dart:async';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Screens/HomeScreens/HomeScreen.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
    _startProgress();
    _initializeApp();
    Provider.of<Products>(context,listen:false).getProducts();
    Provider.of<Products>(context,listen:false).getProductsViewed();
    Provider.of<Stories>(context,listen:false).loadUserStoriesData();
  }

  /// Fonction pour initialiser l'application et vérifier le token et les paramètres
  Future<void> _initializeApp() async {
    String? accessToken = await storage.read(key: 'access_token');
    String? parametre = await storage.read(key: 'parametre');

    // Vérification du token pour la navigation
    _navigationTimer = Timer(Duration(seconds: durationInSeconds), () {
      if (!mounted) return;
      if (accessToken != null && accessToken.isNotEmpty) {
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

    // Appel de la fonction pour charger les données de l'utilisateur
    _loadUserDataBasedOnParam(parametre);
  }

  /// Fonction qui charge les données de l'utilisateur en fonction de la valeur de "parametre"
  void _loadUserDataBasedOnParam(String? parametre) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (parametre == "normal") {
        Provider.of<AuthService>(context, listen: false).loadUserData();
      } else {
        Provider.of<AuthService>(context, listen: false).loadUserGoogleData();
      }
    });
  }

  void _startProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        progress += 0.1 / durationInSeconds; // Mise à jour toutes les 100ms
        if (progress >= 1.0) {
          timer.cancel();
        }
      });
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: const Stack(
                children: [
                  // Possible élément à ajouter plus tard
                ],
              ),
            ),
            SvgPicture.asset(
              "assets/images/logoapp.svg",
              width: 89.7,
              height: 113.49,
            ),
            const SizedBox(height: 20),
            const Text(
              'Finesse',
              style: TextStyle(
                color: Color(0xFFFB98B7),
                fontSize: 40,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Buy and sell your clothes easily and quickly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 33),
            // Barre de progression animée
            Container(
              width: 247,
              height: 10,
              child: Stack(
                children: [
                  Container(
                    width: 247,
                    height: 10,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 247 * progress,
                    height: 10,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFB98B7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}