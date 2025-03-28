import 'dart:convert';

import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/AuthScreens/CompleteInfo.dart';
import 'package:finesse_frontend/Screens/AuthScreens/VerificationMail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    final theme = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                const SizedBox(height: 96),
                const Text(
                  'Créer un compte',
                  style: TextStyle(
                    //color: Color(0xFF111928),
                    fontSize: 32,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    height: 1.38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Complétez les informations sur\nvotre compte",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //color: Color(0xFF111928),
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
                        label: "Votre adresse e-mail",
                        isPassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer votre e-mail.";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Veuillez entrer un e-mail valide.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _passwordController,
                        label: "Mot de passe",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer un mot de passe.";
                          }
                          if (value.length < 8) {
                            return "Le mot de passe doit comporter au moins 8 caractères.";
                          }
                          if (!RegExp(r'^(.*[A-Z].*)').hasMatch(value)) {
                            return "Le mot de passe doit contenir au moins une lettre majuscule.";
                          }

                          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              .hasMatch(value)) {
                            return "Le mot de passe doit contenir au moins 1 caractère spécial.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _confirmPassController,
                        label: "Confirmer le mot de passe",
                        isPassword: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Les mots de passe ne correspondent pas.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        textColor:
                            _isLoading ? Color(0xFF111928) : Colors.white,
                        buttonColor:
                            _isLoading ? Color(0xFFE5E7EB) : Colors.black,
                        onTap: _isLoading
                            ? () {}
                            : () async {
                                setState(() {
                                  _errorMessage =
                                      null; // Réinitialiser le message d'erreur
                                });

                                // Vérification des conditions
                                if (_emailController.text.isEmpty ||
                                    !_emailController.text.contains('@') ||
                                    !_emailController.text.contains('.')) {
                                  setState(() {
                                    _errorMessage =
                                        "Veuillez entrer un email valide.";
                                  });
                                } else if (_passwordController.text.length <
                                    8) {
                                  setState(() {
                                    _errorMessage =
                                        "Le mot de passe doit contenir au moins 8 caractères.";
                                  });
                                } else if (!_passwordController.text
                                    .contains(RegExp(r'[A-Z]'))) {
                                  setState(() {
                                    _errorMessage =
                                        "Le mot de passe doit contenir au moins 1 majuscules.";
                                  });
                                } else if (!_passwordController.text.contains(
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                  setState(() {
                                    _errorMessage =
                                        "Le mot de passe doit contenir un caractère spécial.";
                                  });
                                } else if (_passwordController.text !=
                                    _confirmPassController.text) {
                                  setState(() {
                                    _errorMessage =
                                        "Les mots de passe ne correspondent pas.";
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    await Provider.of<AuthService>(context,
                                            listen: false)
                                        .signUp(
                                      username:
                                          _emailController.text.split('@')[0],
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      phoneNumber: "",
                                      firstName: "",
                                      lastName: "",
                                      fcmToken: await FirebaseMessaging.instance
                                          .getToken(),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerificationMail(
                                            email: _emailController.text,
                                            parametre: "signup"),
                                      ),
                                    );
                                  } catch (error) {
                                    setState(() {
                                      _errorMessage =
                                          "cette adresse mail est déjà associé à un autre compte";
                                    });
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        label: _isLoading ? 'Chargements...' : 'Continuer',
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Ou utilisez',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //color: Color(0xFF111928),
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
                          _errorMessage =
                              null; // Réinitialise le message d'erreur
                        });
                        try {
                          final result = await Provider.of<AuthService>(context,
                                  listen: false)
                              .signUpGoogle(
                                  fcmToken: await FirebaseMessaging.instance
                                      .getToken());

                          if (result.statusCode == 200) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CompleteInfo(parameter: "google")),
                            );
                          } else {
                            setState(() {
                              _errorMessage =
                                  "${jsonDecode(result.body)["message"]}";
                            });
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage =
                                "cette adresse mail est déjà associé à un autre compte";
                          });
                        }
                      },
                      imagePath: "assets/Icons/google.svg",
                    ),
                    const SizedBox(width: 8.86),
                    CustomContainer(
                      onTap: () async {
                        setState(() {
                          _errorMessage =
                              null; // Réinitialise le message d'erreur
                        });
                        try {
                          final result = await Provider.of<AuthService>(context,
                                  listen: false)
                              .signUpFacebook(
                            fcmToken:
                                await FirebaseMessaging.instance.getToken(),
                          );

                          if (result.statusCode == 200) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CompleteInfo(parameter: "facebook")),
                            );
                          } else if (result.statusCode == 400) {
                            final responseData =
                                jsonDecode(result.body); // Décodage du JSON
                            setState(() {
                              _errorMessage =
                                  "cette adresse mail est déjà associé à un autre compte";
                            });
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = "Erreur de connexion avec Facebook";
                          });
                        }
                      },
                      imagePath: "assets/Icons/facebook.svg",
                    ),
                    const SizedBox(width: 8.86),
                    CustomContainer(
                      onTap: () async {
                        setState(() {
                          _errorMessage = null;
                        });
                        try {
                          final result = await Provider.of<AuthService>(context,
                                  listen: false)
                              .signUpApple(
                            fcmToken:
                                await FirebaseMessaging.instance.getToken(),
                          );

                          if (result.statusCode == 200) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CompleteInfo(parameter: "apple")),
                            );
                          } else {
                            final responseData =
                                jsonDecode(result.body); // Décodage du JSON
                            setState(() {
                              _errorMessage =
                                  "Une erreur inconnue est survenue.";
                            });
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = "Erreur de connexion avec apple";
                          });
                        }
                      },
                      imagePath: "assets/Icons/apple.svg",
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Vous avez déjà un compte ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: Color(0xFF111928),
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                          );
                        },
                        child: Text(
                          "Connectez-vous maintenant",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme
                                ? Color.fromARGB(255, 249, 217, 144)
                                : Colors.black,
                            fontSize: 16,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration
                                .underline, // Ajout de la sous-ligne
                            decorationColor: theme
                                ? Color.fromARGB(255, 249, 217,
                                    144) // Couleur de la ligne selon le thème
                                : Colors
                                    .black, // Couleur de la ligne selon le thème
                          ),
                        )),
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
