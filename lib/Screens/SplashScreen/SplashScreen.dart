import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Fonction pour initialiser l'application et mettre à jour la barre de progression
  Future<void> _initializeApp() async {
    double step = 1 / 4; // 4 étapes de progression

    String? accessToken = await storage.read(key: 'access_token');
    setState(() => progress += step); // Étape 1 : Lecture du token

    String? parametre = await storage.read(key: 'parametre');
    setState(() => progress += step); // Étape 2 : Lecture des paramètres

    await Future.wait([
      Provider.of<Products>(context, listen: false).getProducts(),
      Provider.of<Products>(context, listen: false).getProductsViewed(),
      Provider.of<Stories>(context, listen: false).loadUserStoriesData(),
    ]);
    setState(() => progress += step); // Étape 3 : Chargement des produits et stories

    _loadUserDataBasedOnParam(parametre);
    setState(() => progress = 1.0); // Étape 4 : Chargement terminé

    _navigateToNextScreen(accessToken);
  }

  /// Charge les données utilisateur en fonction du paramètre sauvegardé
  void _loadUserDataBasedOnParam(String? parametre) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (parametre == "normal") {
        Provider.of<AuthService>(context, listen: false).loadUserData();
      } else {
        Provider.of<AuthService>(context, listen: false).loadUserGoogleData();
      }
    });
  }

  /// Navigue vers l'écran suivant une fois le chargement terminé
  void _navigateToNextScreen(String? accessToken) {
    bool user = Provider.of<AuthService>(context,listen:false).currentUser != null;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => accessToken != null && accessToken.isNotEmpty && user
              ? Navigation(onItemSelected: (int value) {}, currentIndex: 0)
              : const SignInScreen(),
        ),
      );
    });
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
            SvgPicture.asset(
              "assets/images/logoapp.svg",
              width: 148,
              height: 181,
            ),
            const SizedBox(height: 20),
            const Text(
              'Achetez et vendez vos vêtements facilement et rapidement.',
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
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  /// Widget pour afficher la barre de progression dynamique
  Widget _buildProgressBar() {
    return Container(
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
            duration: const Duration(milliseconds: 500),
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
    );
  }
}
