import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnPolicyScreen extends StatelessWidget {
  const ReturnPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Politique de Retour",
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chez Finos, nous nous engageons à ce que vous soyez entièrement satisfait de votre achat.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Si vous souhaitez retourner un produit défectueux ou qui ne correspond pas à la description, voici les conditions de notre politique de retour :",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Raleway',
              ),
            ),
            SizedBox(height: 15),
            _buildPolicyPoint("Délai de retour",
                "Vous avez 24 heures à compter de la réception de votre commande pour faire une demande de retour." , context),
            _buildPolicyPoint("État du produit",
                "Les articles retournés doivent être dans leur état d’origine, non utilisés, et remis dans leur emballage d’origine." , context),
            _buildPolicyPoint("Procédure de retour",
                "Pour initier un retour, veuillez contacter notre service client à [adresse e-mail/numéro de téléphone] dans les 24 heures suivant la réception de votre commande." , context),
            _buildPolicyPoint("Frais de retour",
                "Les frais de retour sont à la charge du client." , context),
            _buildPolicyPoint("Remboursement",
                "Une fois l’article retourné et inspecté, nous procéderons à un remboursement intégral dans un délai de 5 jours ouvrables." , context),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyPoint(String title, String description , BuildContext context) {
        final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color:isDarkMode
                      ? Color.fromARGB(255, 249, 217, 144)
                      : Color(0xFFFB98B7), size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway',
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Raleway',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
