import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsContainer extends StatelessWidget {
  final String title;
  final String content;

  const DetailsContainer({super.key, required this.title, required this.content});

  String formatText(String title , String text) {
    // Ne pas formater "Déposé"
    if (title == "Déposé") {
      return text;
    }

    // Remplacer les caractères _ par un espace
    String formattedText = text.replaceAll('_', ' ');

    // Mettre la première lettre de chaque mot en majuscule
    formattedText = formattedText.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');

    return formattedText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      padding: EdgeInsets.all(8), // Ajout de padding autour du texte
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Coins arrondis
        border: Border.all(
          color: Colors.grey, // Bordure grise
          width: 1, // Largeur de la bordure
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: "Raleway",
              color: theme
                  ? Color.fromARGB(255, 249, 217, 144)
                  : Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            formatText(title,content.replaceAll(RegExp(r"[(),']"), "")),
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          )
        ],
      ),
    );
  }
}
