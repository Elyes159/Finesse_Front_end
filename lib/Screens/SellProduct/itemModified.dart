import 'package:finesse_frontend/Screens/HomeScreens/HomeScreen.dart';
import 'package:finesse_frontend/Screens/SellProduct/SellproductScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ItemModified extends StatefulWidget {
  const ItemModified({super.key});

  @override
  State<ItemModified> createState() => _ItemModifiedState();
}

class _ItemModifiedState extends State<ItemModified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Texte "Sell item" en haut
          const SizedBox(
            height: 40,
          ),
          
          const Spacer(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 343,
                  child: Text(
                    'Article modifié avec succès.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //color: Color(0xFF334155),
                      fontSize: 24,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      height: 1.17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const SizedBox(
                  width: 343,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Les modifications ont été enregistrées et sont désormais visibles.',
                          style: TextStyle(
                            //color: Color(0xFF334155),
                            fontSize: 14,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            height: 1.43,
                          ),
                        ),
                        
                        
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8),
                  child: CustomButton(
                      label: "Ajouter plus d'articles",
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellProductScreen(),
                          ),
                          (route) => false,
                        );
                      }),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () async {
                    final String? parametre = await const FlutterSecureStorage()
                        .read(key: 'parametre');

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Navigation(
                          onItemSelected: (int value) {
                            value = 0;
                          },
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: const SizedBox(
                    width: 343,
                    child: Text(
                      "Retour à l'accueil",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: Color(0xFF111928),
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
