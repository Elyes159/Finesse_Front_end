import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Livraison extends StatefulWidget {
  const Livraison({super.key});

  @override
  State<Livraison> createState() => _LivraisonState();
}

class _LivraisonState extends State<Livraison> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paiement',
          style: TextStyle(
            //color: Colors.black,
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.50,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
          ),
          SvgPicture.asset("assets/Icons/truck-time.svg",
              color: theme ? Color.fromARGB(255, 249, 217, 144) : null),
          SizedBox(
            height: 24,
          ),
          Text(
            'Merci pour\nvotre achat',
            textAlign: TextAlign.center,
            style: TextStyle(
              //color: Color(0xFF334155),
              fontSize: 24,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Votre commande sera bientôt en route',
            textAlign: TextAlign.center,
            style: TextStyle(
              //color: Color(0xFF334155),
              fontSize: 14,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w500,
              height: 1.43,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8),
            child: CustomButton(
                label: "Retour à l'accueil",
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Navigation(
                        onItemSelected: (int value) {},
                      ),
                    ),
                    (Route<dynamic> route) =>
                        false, // Cela va supprimer toutes les pages de la pile
                  );
                }),
          ),
        ],
      ),
    );
  }
}
