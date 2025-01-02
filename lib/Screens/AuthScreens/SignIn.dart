import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignUpScreen.dart';
import 'package:finesse_frontend/Screens/HomeScreen/HomeScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/SocialMediaSignIn.dart';
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
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 96),
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
            const SizedBox(height: 10),
            const SizedBox(
              width: 251,
              height: 48,
              child: Text(
                'Enter your e-mail or username\nand password',
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
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _usernameController,
                    label: "Username or Email",
                    isPassword: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username or email';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['username'] = value!,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _passwordController,
                    label: "Your password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['password'] = value!,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: _isLoading ? "Loading..." : "Login", // Change the label dynamically
                    onTap: _isLoading
                        ? (){}
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
                                    builder: (context) => const HomeScreen(parameter: "normal"),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } catch (e) {
                                setState(() {
                                  _errorMessage = 'Verify your password or username';
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          fontFamily: "Raleway",
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                              builder: (context) => HomeScreen(parameter: "google")),
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
                            'Erreur lors de la connexion avec Google: $e';
                      });
                    }
                  },
                  imagePath: "assets/Icons/google.svg",
                ),
                const SizedBox(width: 8.86),
                CustomContainer(onTap: () {}, imagePath: "assets/Icons/facebook.svg"),
                const SizedBox(width: 8.86),
                // CustomContainer(onTap: () {}, imagePath: "assets/Icons/apple.svg"),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No account yet?',
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
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: const Text(
                    ' Sign up now',
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
    );
  }
}


