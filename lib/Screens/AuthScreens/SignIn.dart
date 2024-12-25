import 'package:finesse_frontend/Provider/AuthService.dart';
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
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return  const Scaffold(
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}