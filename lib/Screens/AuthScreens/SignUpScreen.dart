import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child : ListView(
          children: const [
            SizedBox(height: 96,),
            Text(
                'Create an account',
                style: TextStyle(
                    color: Color(0xFF111928),
                    fontSize: 32,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    height: 1.38,
                    
                ),
                textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: 207,
              height: 48,
              child: Text(
                  'Fill in information about\nyour account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF111928),
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      height: 1.38,
                  ),
              ),
          )
          ],
        )
      ) ,
    );
  }
}