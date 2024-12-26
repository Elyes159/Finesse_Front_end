import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/LoginTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String , String> _formData = {};
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
              color: Color(0xFF111928),
              fontSize: 32,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              height: 1.38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            const SizedBox(
              width: 251,
              height: 48,
              child: Text(
                'Enter your e-mail or username and password',
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
            const SizedBox(height: 24,),
            CustomTextFormField(controller: _usernameController, label: "username or Email",isPassword: false,),
            const SizedBox(height: 16,),
            CustomTextFormField(controller: _passwordController, label: "Your password",isPassword: true,),
            const SizedBox(height: 16,),
            CustomButton(label: "Login", onTap: (){})
          ],
        ),
      ),
    );
  }
}