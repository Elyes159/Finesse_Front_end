import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/DescTextField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // Importer le package http
import 'dart:convert'; // Pour encoder les données en JSON

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  late TextEditingController _emailController;
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Utiliser Provider après l'initialisation du widget
    _emailController = TextEditingController(
      text: Provider.of<AuthService>(context, listen: false)
          .currentUser!
          .email, // Assurez-vous que le type fourni est correct.
    );
  }

  // Fonction pour envoyer l'email via Django
  Future<void> _sendEmail() async {
    final email = _emailController.text;
    final message = _messageController.text;

    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Réinitialiser le message d'erreur
    });

    // URL de votre API Django pour envoyer l'email
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/send-email/');
    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        // Si l'email est envoyé avec succès
        setState(() {
          _errorMessage = 'Email envoyé avec succès';
        });
      } else {
        // Si une erreur se produit
        setState(() {
          _errorMessage = 'Erreur lors de l\'envoi de l\'email';
        });
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de l\'email: $e');
      setState(() {
        _errorMessage = 'Erreur lors de l\'envoi de l\'email';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              "Centre d'aide",
              style: TextStyle(
                //color: Color(0xFF111928),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                height: 1.25,
                letterSpacing: 0.50,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Envoyer un message",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Raleway',
                 ),
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              label: 'ton e-mail',
              isPassword: false,
            ),
            SizedBox(height: 20),
            DescTextField(
              controller: _messageController,
              label: 'message',
              isPassword: false,
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(
                  color: _errorMessage.contains('Erreur') ? Colors.red : Colors.green,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                ),
              ),
            SizedBox(height: 20),
            CustomButton(
              onTap: _isLoading ? (){} : _sendEmail, // Désactiver le bouton si en chargement
              label: _isLoading ? 'Envoi en cours...' : 'Envoyer un email',
              textColor: Colors.white,
              buttonColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
