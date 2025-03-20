import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/AuthScreens/PasswordReset.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignUpScreen.dart';
import 'package:finesse_frontend/Screens/HomeScreens/HomeScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/SocialMediaSignIn.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = ''; // Variable pour stocker l'erreur
  bool _isLoading = false; // Variable pour gérer l'état du chargement
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true; // Commencer le chargement
        _errorMessage = ''; // Effacer les erreurs précédentes
      });
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        await authService.signIn(
          username: _formData['username']!,
          password: _formData['password']!,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(parameter: "normal"),
          ),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        setState(() {
          _errorMessage = 'Verify your password or username';
        });
      } finally {
        setState(() {
          _isLoading = false; // Arrêter le chargement
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        final theme = Provider.of<ThemeProvider>(context).isDarkMode;

    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            const SizedBox(height: 96),
            const Text(
              'Bienvenue',
              style: TextStyle(
                //color: Color(0xFF111928),
                fontSize: 32,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                height: 1.38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 251,
              height: 48,
              child: Text(
                "Se connecter à Finos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: Color(0xFF111928),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.38,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _usernameController,
                    label: "Nom d'utilisateur",
                    isPassword: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer un nom d'utilisateur.";
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['username'] = value!,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _passwordController,
                    label: "Mot de passe",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['password'] = value!,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordReset()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Mot de passe oublié ?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //color: Color(0xFF111928),
                              fontSize: 14,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    textColor: _isLoading ? Color(0xFF111928) : Colors.white,
                    buttonColor:
                        _isLoading ? Color(0xFFE5E7EB) : Color(0xFFFB98B7),
                    label: _isLoading
                        ? "Chargement..."
                        : "Se connecter", // Change the label dynamically
                    onTap: _isLoading
                        ? () {}
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                _isLoading = true; // Start loading
                                _errorMessage = ''; // Clear previous errors
                              });
                              try {
                                await authService.signIn(
                                  username: _formData['username']!,
                                  password: _formData['password']!,
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Navigation(onItemSelected: (int value) {  },),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } catch (e) {
                                setState(() {
                                  _errorMessage =
                                      "Vérifiez votre mot de passe ou nom d'utilisateur";
                                });
                              } finally {
                                setState(() {
                                  _isLoading = false; // Stop loading
                                });
                              }
                            }
                          },
                  ),
                  if (_errorMessage.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontFamily: "Raleway",
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
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
            // Social Media Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                  onTap: () async {
                    try {
                      bool isLoggedIn =
                          await Provider.of<AuthService>(context, listen: false)
                              .googleLogin();
                      if (isLoggedIn) {
                        Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Navigation(onItemSelected: (int value) {  },),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                      } else {
                        setState(() {
                          _errorMessage =
                              'L\'email n\'existe pas dans la base de données. Vous pouvez vous inscrire.';
                        });
                      }
                    } catch (e) {
                      setState(() {
                        _errorMessage =
                            'Erreur lors de la connexion avec Google';
                      });
                    }
                  },
                  imagePath: "assets/Icons/google.svg",
                ),
                const SizedBox(width: 8.86),
                CustomContainer(
                    onTap: () async {
                      try {
                        bool isLoggedIn = await Provider.of<AuthService>(
                                context,
                                listen: false)
                            .facebookLogin();
                        if (isLoggedIn) {
                         Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Navigation(onItemSelected: (int value) {  },),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                        } else {
                          setState(() {
                            _errorMessage =
                                'Ce compte n\'existe pas dans la base de données. Vous pouvez vous inscrire.';
                          });
                        }
                      } catch (e) {
                        setState(() {
                          _errorMessage =
                              'Erreur lors de la connexion avec facebook';
                        });
                      }
                    },
                    imagePath: "assets/Icons/facebook.svg"),
                const SizedBox(width: 8.86),
                CustomContainer(onTap: () async {
                      try {
                        bool isLoggedIn = await Provider.of<AuthService>(
                                context,
                                listen: false)
                            .appleLogin();
                        if (isLoggedIn) {
                         Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Navigation(onItemSelected: (int value) {  },),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                        } else {
                          setState(() {
                            _errorMessage =
                                'Ce compte n\'existe pas dans la base de données. Vous pouvez vous inscrire.';
                          });
                        }
                      } catch (e) {
                        setState(() {
                          _errorMessage =
                              'Erreur lors de la connexion avec facebook';
                        });
                      }
                    }, imagePath: "assets/Icons/apple.svg"),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tu n'as pas de compte? ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //color: Color(0xFF111928),
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: Text(
                    ' Inscrivez-vous maintenant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme? Color.fromARGB(255, 249, 217, 144):  Color(0xFFC668AA),
                      fontSize: 14,
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
    );
  }
}
