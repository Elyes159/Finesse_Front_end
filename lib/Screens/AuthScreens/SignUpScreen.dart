import 'dart:convert';

import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/CompleteInfo.dart';
import 'package:finesse_frontend/Screens/AuthScreens/VerificationMail.dart';
import 'package:flutter/material.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/SocialMediaSignIn.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ListView(
              children: [
                const SizedBox(height: 96),
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
                const SizedBox(height: 10),
                const Text(
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
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _emailController,
                        label: "Your e-mail address",
                        isPassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _passwordController,
                        label: "Password",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password.';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _confirmPassController,
                        label: "Confirm password",
                        isPassword: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                         textColor: _isLoading ? Color(0xFF111928) : Colors.white,
                  buttonColor: _isLoading? Color(0xFFE5E7EB) : Color(0xFFFB98B7),
                        onTap: _isLoading
                            ? () {}
                            : () async {
                                setState(() {
                                  _errorMessage = null; // Reset error message
                                });
                                if (_formKey.currentState?.validate() ?? false) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    await Provider.of<AuthService>(context, listen: false).signUp(
                                      username: _emailController.text.split('@')[0],
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      phoneNumber: "",
                                      firstName: "",
                                      lastName: "",
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const VerificationMail(parametre: "signup",)),
                                    );
                                  } catch (error) {
                                    setState(() {
                                      _errorMessage = error.toString();
                                    });
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        label: _isLoading ? 'Loading...' : 'Continue',
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 14,fontFamily: "Raleway",fontWeight:FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Or use',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF111928),
                    fontSize: 14,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   CustomContainer(
                      onTap: () async {
                        setState(() {
                          _errorMessage = null; // Réinitialise le message d'erreur
                        });
                        try {
                          final result = await Provider.of<AuthService>(context, listen: false).signUpGoogle();

                          if (result.statusCode == 200) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => CompleteInfo(parameter: "google")),
                            );
                          } else {
                            setState(() {
                              _errorMessage = "${jsonDecode(result.body)["message"]}";
                            });
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = "Error signing in with Google: ${e.toString()}";
                          });
                        }
                      },
                      imagePath: "assets/Icons/google.svg",
                    ),

                    const SizedBox(width: 8.86),
                    CustomContainer(
                      onTap: () async {
                        setState(() {
                          _errorMessage = null; // Réinitialise le message d'erreur
                        });
                        try {
                          final result = await Provider.of<AuthService>(context, listen: false).signUpFacebook();

                          if (result.statusCode == 200) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => CompleteInfo(parameter: "facebook")),
                            );
                          } else {
                            final responseData = jsonDecode(result.body); // Décodage du JSON
                            setState(() {
                              _errorMessage = responseData["message"] ?? "An unknown error occurred.";
                            });
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = "Error signing in with Facebook: ${e.toString()}";
                          });
                        }
                      },
                      imagePath: "assets/Icons/facebook.svg",
                    ),

                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
