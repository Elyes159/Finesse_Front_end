import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Politique de Confidentialité',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Introduction',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Votre vie privée est importante pour nous. Cette politique explique comment nous collectons, utilisons et protégeons vos informations personnelles.',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Collecte des informations',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nous collectons des informations que vous nous fournissez directement, telles que votre nom, adresse e-mail et numéro de téléphone.',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Utilisation des informations',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vos informations sont utilisées pour améliorer notre service, personnaliser votre expérience et vous contacter en cas de besoin.',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Protection des informations',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
            "Nous mettons en place des mesures de sécurité pour protéger vos données contre l'accès non autorisé ou la divulgation.",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Contact',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Si vous avez des questions concernant cette politique, vous pouvez nous contacter à privacy@finesse.com.',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
