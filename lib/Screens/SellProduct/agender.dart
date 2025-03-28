import 'package:finesse_frontend/Screens/SellProduct/bchoice.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:flutter/material.dart';

class Gender extends StatefulWidget {
  final bool? isExplore;
  const Gender({super.key, this.isExplore});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String gender = "";
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              CustomDropdownFormField<String, String>(
                isButton: true,
                onTap: () {
                  gender = "homme";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BChoice(
                            genderForFiled: gender,
                              gender: "h", isExplore: widget.isExplore)));
                },
                label: "Hommes",
                image: true,
                pathImageHorsmenu: "assets/images/homme.jpeg",
                options: const [
                  {"unkown": "unkown"},
                ],
                selectedKey: null,
              ),
              SizedBox(
                height: 16,
              ),
              CustomDropdownFormField<String, String>(
                isButton: true,
                onTap: () {
                  
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BChoice(
                            genderForFiled: "femme",
                              gender: "f", isExplore: widget.isExplore)));
                },
                label: "Femmes",
                imageMenu: false,
                image: true,
                pathImageHorsmenu: "assets/images/femme.jpeg",
                options: const [
                  {"unkown": "unkown"},
                ],
              ),
              SizedBox(
                height: 16,
              ),
              CustomDropdownFormField<String, String>(
                isButton: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BChoice(
                            genderForFiled: "garçon",
                              gender: "g", isExplore: widget.isExplore)));
                },
                label: "Garçons",
                image: true,
                onChanged: (value) {},
                pathImageHorsmenu: "assets/images/garcon.jpeg",
                options: const [
                  {"unkown": "unkown"},
                ],
              ),
              SizedBox(
                height: 16,
              ),
              CustomDropdownFormField<String, String>(
                isButton: true,
                label: "Filles",
                image: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BChoice(
                            genderForFiled: "petite fille",
                              gender: "p", isExplore: widget.isExplore)));
                },
                pathImageHorsmenu: "assets/images/fille.jpeg",
                options: const [
                  {"unkown": "unkown"},
                ],
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
