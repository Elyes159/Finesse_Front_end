import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Badges extends StatefulWidget {
  const Badges({super.key});

  @override
  State<Badges> createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  // Exemple d'entiers, vous pouvez les ajuster selon votre logique
  int vendeurRecommande = 1; // Exemple pour le vendeur recommandé (0-3)
  int vendeurExpert = 1; // Exemple pour le vendeur expert (0-10)
@override
  void initState() {
    super.initState();
    // Récupérer la valeur depuis le Provider une fois l'état initialisé
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        vendeurRecommande = Provider.of<AuthService>(context, listen: false).number_of_orders;
                vendeurExpert = Provider.of<AuthService>(context, listen: false).number_of_orders;

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes stats",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.25,
            letterSpacing: 0.50,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset("assets/Icons/lock.svg"),
                )),
            SizedBox(
              height: 8,
            ),
            Text("Obtenir un badge" , style: TextStyle(fontFamily: "Raleway" , fontWeight: FontWeight.bold),),
            SizedBox(
              height: 8,
            ),
            Text("Des avantages exclusifs pour vos achats et vos ventes" , style: TextStyle(fontFamily: "Raleway" , ),),
            SizedBox(height: 50,),
            Divider(),
            SizedBox(
              height: 100,
            ),
            // Vendeur Recommandé - Progression sur 3
            _buildBadgeContainer(
              title: "Vendeur recommandé",
              progressValue: vendeurRecommande / 3,
              currentValue: vendeurRecommande,
              maxValue: 3,
              iconPath: "assets/Icons/recom.svg",
              progressColor: Colors.black,
            ),
            SizedBox(height: 20),
            _buildBadgeContainer(
              title: "Vendeur expert",
              progressValue: vendeurExpert / 10,
              currentValue: vendeurExpert,
              maxValue: 10,
              iconPath: "assets/Icons/expert.svg",
              progressColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeContainer({
    required String title,
    required double progressValue,
    required int currentValue,
    required int maxValue,
    required String iconPath,
    required Color progressColor,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SizedBox(width: 20),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(iconPath),
            ),
          ),
          SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              fontFamily: "Raleway",
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: progressValue, // Remplissage selon le badge
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              Text(
                "$currentValue/$maxValue",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
