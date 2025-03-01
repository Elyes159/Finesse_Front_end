import 'package:finesse_frontend/Screens/SellProduct/bchoice.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:flutter/material.dart';

class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  @override
  Widget build(BuildContext context) {
    String gender;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Text(
              "Choisissez le sexe du produit",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: 0.50,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50,),
            CustomDropdownFormField<String, String>(
              isButton: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BChoice(gender: "h")));
              },
              label: "Hommes",
              image: true,
              pathImageHorsmenu: "assets/images/homme.jpeg",
              options: const [
                {"unkown": "unkown"},
              ],
              
              selectedKey: null,
            ),
            SizedBox(height: 16,),
            CustomDropdownFormField<String, String>(
              isButton: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BChoice(gender: "f")));
              },
              label: "Femmes",
              imageMenu: false,
              image: true,
              pathImageHorsmenu: "assets/images/femme.jpeg",
              options: const [
                {"unkown": "unkown"},
              ],
            ),
            SizedBox(height: 16,),
            CustomDropdownFormField<String, String>(
              isButton: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BChoice(gender: "g")));
              },
              label: "Garçons",
              image: true,
               onChanged: (value) {
                
              },
              pathImageHorsmenu: "assets/images/garcon.jpeg",
              options: const [
                {"unkown": "unkown"},
              ],
            ),
            SizedBox(height: 16,),
            CustomDropdownFormField<String, String>(
              isButton: true,
              
              label: "Filles",
              image: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BChoice(gender: "p")));
              },
              pathImageHorsmenu: "assets/images/fille.jpeg",
              options: const [
                {"unkown": "unkown"},
              ],
            ),
            SizedBox(height: 24,),
            CustomButton(label: "choisir le sexe", onTap: (){})
          ],
        ),
      ),
    );
  }
}
