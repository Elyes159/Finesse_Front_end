import 'dart:async';

import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
 void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SignInScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor: Colors.amber,);
  }
}