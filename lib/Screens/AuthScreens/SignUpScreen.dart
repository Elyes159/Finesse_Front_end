import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/SocialMediaSignIn.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/LoginTextField.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child : ListView(
          children: [
            const SizedBox(height: 96,),
            const Text(
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
            const SizedBox(height: 10,),
            const SizedBox(
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
          ),
          SizedBox(height: 24,),
          CustomTextFormField(controller: _emailController, label: "Your e-mail address", isPassword: false),
          SizedBox(height: 16,),
          CustomTextFormField(controller: _passwordController, label: "Password", isPassword: true),
          SizedBox(height: 16,),
          CustomTextFormField(controller: _emailController, label: "Confirm password", isPassword: true),
          SizedBox(height: 16,),
          CustomButton(label: "Continue", onTap: (){

          }),
          SizedBox(height: 32,),
            Text(
              'Or use',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 14,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 14,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(onTap: (){}, imagePath: "assets/Icons/google.svg",),
                SizedBox(width: 8.86,),
                CustomContainer(onTap: (){}, imagePath: "assets/Icons/facebook.svg"),
                SizedBox(width: 8.86,),
                CustomContainer(onTap: (){}, imagePath: "assets/Icons/apple.svg"),
              ],
            ),
            SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF111928),
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
                  },
                  child: Text(
                    ' Login now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFC668AA),
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ) ,
    );
  }
}