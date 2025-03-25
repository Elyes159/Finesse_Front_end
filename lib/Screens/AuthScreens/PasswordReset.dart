import 'dart:convert';

import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/VerificationMail.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  bool isLoading = false; // To hold the email validation error message
  final storage = FlutterSecureStorage();

  bool _isEmailValid = false;
  String _errorMessage = ""; // Variable pour stocker l'erreur
// Initially false, only becomes true when the email is valid

  // Simple regex for basic email validation
  bool _validateEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  // Validate email when user types
  void _validateEmailOnChange() {
    setState(() {
      if (_validateEmail(_emailController.text)) {
        _isEmailValid = true;
        _emailError = null;
      } else {
        _isEmailValid = false;
        _emailError = 'Please enter a valid email address';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController
        .addListener(_validateEmailOnChange); // Listen to text changes
  }

  @override
  void dispose() {
    _emailController.removeListener(
        _validateEmailOnChange); // Remove listener when not needed
    super.dispose();
  }

  void _onSendCodeTap() {
    if (_isEmailValid) {
      // Call API here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: ListView(
        children: [
          SizedBox(height: 12),
          Text(
            'Réinitialisation du mot de passe',
            textAlign: TextAlign.center,
            style: TextStyle(
              //color: Color(0xFF111928),
              fontSize: 36,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
              height: 1.22,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 267,
            child: Text(
              'Entrez votre e-mail pour recevoir\nle code de vérification',
              textAlign: TextAlign.center,
              style: TextStyle(
                //color: Color(0xFF111928),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                height: 1.50,
                letterSpacing: 0.15,
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _emailController,
              label: 'Votre e-mail',
              isPassword: false,
              // We don't need the validator here anymore
            ),
          ),
          SizedBox(height: 0),
          // Display the error message if email is invalid
          if (!_isEmailValid && _emailController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                _emailError ?? '',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),

          SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              label: "Envoyer le code",
              onTap: (!_isEmailValid || isLoading)
                  ? () {}
                  : () async {
                      setState(() {
                        isLoading = true;
                        _errorMessage = ""; // Reset error message
                      });
            
                      try {
                        String? storedemailReset =
                            await storage.read(key: 'email_reset');
                        final result =
                            await Provider.of<AuthService>(context, listen: false)
                                .send_email_to_reset_password(
                                    email: _emailController.text);
            
                        if (result.statusCode == 200) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VerificationMail(parametre: "password")),
                          );
                        } else {
                          setState(() {
                            _errorMessage =
                                "${jsonDecode(result.body)["message"]}";
                          });
                        }
                      } catch (e) {
                        setState(() {
                          _errorMessage = "Erreur lors de la verification de email";
                        });
                      }
            
                      setState(() {
                        isLoading = false;
                      });
                    },
              // Set button color based on loading state and email validity
              buttonColor: isLoading
                  ? Color(0xFFE5E7EB) // Light grey when loading
                  : (_isEmailValid
                      ? Colors.black
                      : Color(0xFFE5E7EB)), // Color when email is valid/invalid
            
              // Set text color based on loading state and email validity
              textColor: isLoading
                  ? Color(0xFF111928) // Dark color when loading (can be adjusted)
                  : (_isEmailValid
                      ? Colors.white
                      : Color(
                          0xFF111928)), // White text when valid, dark when invalid
            ),
          ),
          if (_errorMessage != "")
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
    );
  }
}
