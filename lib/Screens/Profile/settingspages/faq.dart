import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQ',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFAQItem(
              "Qu'est-ce que Finesse ?",
              "Finesse est une application qui vous permet de découvrir et d'acheter des produits tendances facilement et rapidement.",
            ),
            _buildFAQItem(
              'Comment créer un compte ?',
              'Vous pouvez créer un compte en vous inscrivant avec votre adresse e-mail ou votre numéro de téléphone.',
            ),
            _buildFAQItem(
              'Quels modes de paiement sont acceptés ?',
              'Nous acceptons les paiements par carte bancaire et portefeuille électronique.',
            ),
            _buildFAQItem(
              'Comment contacter le support ?',
              "Vous pouvez nous contacter via la section 'A propos de nous' de l'application ou par e-mail à support@finesse.com.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              answer,
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
