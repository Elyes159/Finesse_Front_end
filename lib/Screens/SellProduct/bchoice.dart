import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/HomeScreens/Explore.dart';
import 'package:finesse_frontend/Screens/SellProduct/SellproductScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BChoice extends StatefulWidget {
  final bool? isExplore;
  const BChoice(
      {super.key,
      required this.gender,
      this.isExplore,
      required this.genderForFiled});
  final String genderForFiled;
  final String gender;
  @override
  State<BChoice> createState() => _BChoiceState();
}

class _BChoiceState extends State<BChoice> {
  String? categorieForBackend;
  String for_field = "";
  String? getSelectedValue(List<Map<String, String>> options, String? key) {
    for (var option in options) {
      if (option.containsKey(key)) {
        return option[key];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = context.findAncestorStateOfType<NavigationState>();

    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    String? SubCategoryForBackend;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Text(
              "Choisissez une catégorie",
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (widget.gender == "h") ...[
            CustomDropdownFormField<String, String>(
              label: "Vétements",
              image: true,
              pathImageHorsmenu: "assets/images/vt.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTV": "Tous les vêtements"},
                      {"VE": "Vestes et Manteaux"},
                      {"PU": "Mailles et Pulls"},
                      {"T-S": "T-Shirt"},
                      {"CH": "Chemises"},
                      {"PAN": "Pantalons"},
                      {"JEAN": "Jeans"},
                      {"COS": "Costumes"},
                      {"POLO": "Polos"},
                      {"SH": "Shorts"},
                      {"BAIN": "Bain"},
                    ]
                  : const [
                      {"VE": "Vestes et Manteaux"},
                      {"PU": "Mailles et Pulls"},
                      {"T-S": "T-Shirt"},
                      {"CH": "Chemises"},
                      {"PAN": "Pantalons"},
                      {"JEAN": "Jeans"},
                      {"COS": "Costumes"},
                      {"POLO": "Polos"},
                      {"SH": "Shorts"},
                      {"BAIN": "Bain"},
                      {"TOUTV": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTV": "Tous les vétements"},
                    {"VE": "Vestes et Manteaux"},
                    {"PU": "Mailles et Pulls"},
                    {"T-S": "T-Shirt"},
                    {"CH": "Chemises"},
                    {"PAN": "Pantalons"},
                    {"JEAN": "Jeans"},
                    {"COS": "Costumes"},
                    {"POLO": "Polos"},
                    {"SH": "Shorts"},
                    {"BAIN": "Bain"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "V${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Chaussures",
              image: true,
              pathImageHorsmenu: "assets/images/ch.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTC": "Toutes les chaussures"},
                      {"BAS": "Baskets"},
                      {"BO": "Bottes et bottines"},
                      {"MO": "Chaussures plates"},
                      {"SA": "Sandales"},
                      {"ESP": "Espadrilles"},
                    ]
                  : const [
                      //{"TOUTC": "Tout les chaussures"},
                      {"BAS": "Baskets"},
                      {"BO": "Bottes et bottines"},
                      {"MO": "Chaussures plates"},
                      {"SA": "Sandales"},
                      {"ESP": "Espadrilles"},

                      {"TOUTC": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"BAS": "Baskets"},
                    {"BO": "Bottes et bottines"},
                    {"MO": "Chaussures plates"},
                    {"SA": "Sandales"},
                    {"ESP": "Espadrilles"},
                    {"TOUTC": "autres"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "C${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Sacs",
              image: true,
              pathImageHorsmenu: "assets/images/sacs.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTS": "Tous les sacs"},
                      {"SD": "Sacs à dos"},
                      {"PORT": "Petite maroquinerie"},
                      {"CA": "Sacs de voyage"},
                      {"SS": "Cabas"},
                    ]
                  : const [
                      {"SD": "Sacs à dos"},
                      {"PORT": "Petite maroquinerie"},
                      {"CA": "Sacs de voyage"},
                      {"SS": "Cabas"},
                      {"TOUTS": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTS": "Tout les sacs"},
                    {"SD": "Sacs à dos"},
                    {"PORT": "Petite maroquinerie"},
                    {"CA": "Sacs de voyage"},
                    {"SS": "Cabas"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "S${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Accessoires",
              image: true,
              pathImageHorsmenu: "assets/images/acc.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTA": "Tous les accessoires"},
                      {"LU": "Lunettes"},
                      {"CE": "Ceintures"},
                      {"BONN": "Bonnets et Chapeaux"},
                      {"ECH": "Écharpes"},
                      {"CR": "Cravates"},
                      {"PORTF": "Portefeuilles"},
                      {"MONTRE": "Montres et bijoux"},
                      {"BOUTON": "Boutons de manchette"},
                    ]
                  : const [
                      {"LU": "Lunettes"},
                      {"CE": "Ceintures"},
                      {"BONN": "Bonnets et Chapeaux"},
                      {"ECH": "Écharpes"},
                      {"CR": "Cravates"},
                      {"PORTF": "Portefeuilles"},
                      {"MONTRE": "Montres et bijoux"},
                      {"BOUTON": "Boutons de manchette"},
                      {"TOUTA": "autres"}
                    ],
              onChanged: (selectedKey) {
                print("onChanged déclenché avec : $selectedKey");
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTA": "Tous les accessoires"},
                    {"LU": "Lunettes"},
                    {"CE": "Ceintures"},
                    {"BONN": "Bonnets et Chapeaux"},
                    {"ECH": "Écharpes"},
                    {"CR": "Cravates"},
                    {"PORTF": "Portefeuilles"},
                    {"MONTRE": "Montres et bijoux"},
                    {"BOUTON": "Boutons de manchette"},
                  ], selectedKey)!;
                  if (selectedKey != null) {
                    categorieForBackend = selectedKey == "MONTRE"
                        ? "MONTRE"
                        : "A${widget.gender}$selectedKey".toUpperCase();
                  }
                  print(
                      "categorieForBackend mis à jour : $categorieForBackend");
                });
              },
            ),
            SizedBox(
              height: 24,
            ),
            CustomButton(
                buttonColor: categorieForBackend == null
                    ? Colors.grey
                    : theme
                        ? Color.fromARGB(255, 249, 217, 144)
                        : Colors.black,
                label: "choisir",
                onTap: categorieForBackend == null
                    ? () {
                        print(categorieForBackend);
                      }
                    : () {
                        print(categorieForBackend);
                        if (widget.isExplore == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation(
                                        category_for_field:
                                            "${widget.genderForFiled} - $for_field",
                                        from_mv: categorieForBackend,
                                        onItemSelected: (int value) {},
                                        currentIndex: 1,
                                      )));
                        } else {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SellProductScreen(
                          //               category_for_field:
                          //                   "${widget.genderForFiled} $for_field",
                          //               categoryFromMv: categorieForBackend,
                          //             )));

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation(
                                        category_for_field:
                                            "${widget.genderForFiled} - $for_field",
                                        from_mv: categorieForBackend,
                                        onItemSelected: (int value) {},
                                        currentIndex: 2,
                                      )));
                        }
                      })
          ],
          if (widget.gender == "f") ...[
            CustomDropdownFormField<String, String>(
              label: "Vétements",
              image: true,
              pathImageHorsmenu: "assets/images/vt.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTV": "Tous les vêtements"},
                      {"RO": "Robes"},
                      {"CAF": "Caftans"},
                      {"T-S": "T-Shirts"},
                      {"PU": "Pulls"},
                      {"CH": "Chemises"},
                      {"GI": "Gilets"},
                      {"VE": "Vestes et Manteaux"},
                      {"TR": "Trenchs"},
                      {"PAN": "Pantalons"},
                      {"SH": "Shorts"},
                      {"JU": "Jupes"},
                      {"MAI": "Maillots de bain"},
                      {"LIN": "Lingeries"},
                      {"PY": "Pyjamas"},
                      {"COM": "Combinaisons"},
                      {"ENS": "Ensembles"},
                      {"S-V": "Sous vêtements"},
                    ]
                  : const [
                      {"RO": "Robes"},
                      {"CAF": "Caftans"},
                      {"T-S": "T-Shirts"},
                      {"PU": "Pulls"},
                      {"CH": "Chemises"},
                      {"GI": "Gilets"},
                      {"VE": "Vestes et Manteaux"},
                      {"TR": "Trenchs"},
                      {"PAN": "Pantalons"},
                      {"SH": "Shorts"},
                      {"JU": "Jupes"},
                      {"MAI": "Maillots de bain"},
                      {"LIN": "Lingeries"},
                      {"PY": "Pyjamas"},
                      {"COM": "Combinaisons"},
                      {"ENS": "Ensembles"},
                      {"S-V": "Sous vêtements"},
                      {"TOUTV": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTV": "Tous les vêtements"},
                    {"RO": "Robes"},
                    {"CAF": "Caftans"},
                    {"T-S": "T-Shirts"},
                    {"PU": "Pulls"},
                    {"CH": "Chemises"},
                    {"GI": "Gilets"},
                    {"VE": "Vestes et Manteaux"},
                    {"TR": "Trenchs"},
                    {"PAN": "Pantalons"},
                    {"SH": "Shorts"},
                    {"JU": "Jupes"},
                    {"MAI": "Maillots de bain"},
                    {"LIN": "Lingeries"},
                    {"PY": "Pyjamas"},
                    {"COM": "Combinaisons"},
                    {"ENS": "Ensembles"},
                    {"S-V": "Sous vêtements"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "V${widget.gender}$selectedKey".toUpperCase();

                  print(categorieForBackend);
                });
              },
            ),
            
            
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Chaussures",
              image: true,
              pathImageHorsmenu: "assets/images/ch.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTC": "Toutes les chaussures"},
                      {"BO": "Bottes et Bottines"},
                      {"ESC": "Escarpins"},
                      {"COMP": "Compensés"},
                      {"SA": "Sandales"},
                      {"BAS": "Baskets"},
                      {"ESP": "Espadrilles"},
                      {"BALL": "Ballerines"},
                      {"MU": "Mules"},
                    ]
                  : const [
                      {"BO": "Bottes et Bottines"},
                      {"ESC": "Escarpins"},
                      {"COMP": "Compensés"},
                      {"SA": "Sandales"},
                      {"BAS": "Baskets"},
                      {"ESP": "Espadrilles"},
                      {"BALL": "Ballerines"},
                      {"MU": "Mules"},
                      {"TOUTC": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTC": "Toutes les chaussures"},
                    {"BO": "Bottes et Bottines"},
                    {"ESC": "Escarpins"},
                    {"COMP": "Compensés"},
                    {"SA": "Sandales"},
                    {"BAS": "Baskets"},
                    {"ESP": "Espadrilles"},
                    {"BALL": "Ballerines"},
                    {"MU": "Mules"},
                    //{"MO": "Mocassins"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "C${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Sacs",
              image: true,
              pathImageHorsmenu: "assets/images/sacs.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTS": "Tous les sacs"},
                      {"SM": "Sacs à main"},
                      {"BAND": "Sacs à bandoulière"},
                      {"PORT": "Sacs porté épaule"},
                      {"CA": "Sacs cabas"},
                      {"P": "Pochettes"},
                      {"VOY": "Sacs de voyage"},
                      {"SD": "Sac à dos"},
                    ]
                  : const [
                      {"SM": "Sacs à main"},
                      {"BAND": "Sacs à bandoulière"},
                      {"PORT": "Sacs porté épaule"},
                      {"CA": "Sacs cabas"},
                      {"P": "Pochettes"},
                      {"VOY": "Sacs de voyage"},
                      {"SD": "Sac à dos"},
                      {"TOUTS": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTS": "Tous les sacs"},
                    {"SM": "Sacs à main"},
                    {"BAND": "Sacs à bandoulière"},
                    {"PORT": "Sacs porté épaule"},
                    {"CA": "Sacs cabas"},
                    {"P": "Pochettes"},
                    {"VOY": "Sacs de voyage"},
                    {"SD": "Sacs à dos"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "S${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Accessoires",
              image: true,
              pathImageHorsmenu: "assets/images/acc.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTA": "Tous les accesoires"},
                      {"LU": "Lunettes"},
                      {"CE": "Ceintures"},
                      {"CHAP": "Chapeaux et Bonnets"},
                      {"ECH": "Écharpes"},
                      {"FOU": "Foulards"},
                      {"BI": "Bijoux"},
                      {"MONTRE": "Montres"}
                    ]
                  : const [
                      {"LU": "Lunettes"},
                      {"CE": "Ceintures"},
                      {"CHAP": "Chapeaux et Bonnets"},
                      {"ECH": "Écharpes"},
                      {"FOU": "Foulards"},
                      {"BI": "Bijoux"},
                      {"MONTRE": "Montres"},
                      {"TOUTA": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTA": "Tous les accesoires"},
                    {"LU": "Lunettes"},
                    {"CE": "Ceintures"},
                    {"CHAP": "Chapeaux et Bonnets"},
                    {"ECH": "Écharpes"},
                    {"FOU": "Foulards"},
                    {"BI": "Bijoux"},
                    {"MONTRE": "Montres"}
                  ], selectedKey)!;
                  if (selectedKey == "MONTRE") {
                    categorieForBackend = "MONTRE";
                  } else {
                    categorieForBackend =
                        "A${widget.gender}$selectedKey".toUpperCase();
                  }
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 24,
            ),
            CustomButton(
                buttonColor: categorieForBackend == null
                    ? Colors.grey
                    : theme
                        ? Color.fromARGB(255, 249, 217, 144)
                        : Colors.black,
                label: "choisir",
                onTap: categorieForBackend == null
                    ? () {
                        print(categorieForBackend);
                      }
                    : () {
                        print(categorieForBackend);
                        if (widget.isExplore == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation(
                                        category_for_field:
                                            "${widget.genderForFiled} - $for_field",
                                        from_mv: categorieForBackend,
                                        onItemSelected: (int value) {},
                                        currentIndex: 1,
                                      )));
                        } else {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SellProductScreen(
                          //               category_for_field:
                          //                   "${widget.genderForFiled} $for_field",
                          //               categoryFromMv: categorieForBackend,
                          //             )));

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation(
                                        category_for_field:
                                            "${widget.genderForFiled} - $for_field",
                                        from_mv: categorieForBackend,
                                        onItemSelected: (int value) {},
                                        currentIndex: 2,
                                      )));
                        }
                      })
          ],
          if (widget.gender == "p") ...[
            CustomDropdownFormField<String, String>(
              label: "Vétements",
              image: true,
              pathImageHorsmenu: "assets/images/vt.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTV": "Tous les vêtements"},
                      {"BB": "Vêtements Bébé"},
                      {"VE": "Vestes et manteaux"},
                      {"RO": "Robes"},
                      {"MAI": "Mailles"},
                      {"TENU": "Tenues"},
                      {"HAUT": "Hauts"},
                      {"PAN": "Pantalons"},
                      {"JU": "Jupes"},
                      {"SH": "Shorts"},
                    ]
                  : const [
                      {"BB": "Vêtements Bébé"},
                      {"VE": "Vestes et manteaux"},
                      {"RO": "Robes"},
                      {"MAI": "Mailles"},
                      {"TENU": "Tenues"},
                      {"HAUT": "Hauts"},
                      {"PAN": "Pantalons"},
                      {"JU": "Jupes"},
                      {"SH": "Shorts"},
                      {"TOUTV": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTV": "Tous les vêtements"},
                    {"BB": "Vêtements Bébé"},
                    {"VE": "Vestes et manteaux"},
                    {"RO": "Robes"},
                    {"MAI": "Mailles"},
                    {"TENU": "Tenues"},
                    {"HAUT": "Hauts"},
                    {"PAN": "Pantalons"},
                    {"JU": "Jupes"},
                    {"SH": "Shorts"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "V${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Chaussures",
              image: true,
              pathImageHorsmenu: "assets/images/ch.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTC": "Toutes les chaussures"},
                      {"BAS": "Baskets"},
                      {"BO": "Bottes et bottines"},
                      {"SA": "Sandales"},
                      {"BALL": "Ballerines"},
                      {"ESP": "Espadrilles"},
                      {"PLATE": "Chaussures plates"},
                      {"BB": "Premiers pas"},
                      {"LACET": "A lacets"},
                      {"CHAUSS": "Chaussons"},
                    ]
                  : const [
                      {"BAS": "Baskets"},
                      {"BO": "Bottes et bottines"},
                      {"SA": "Sandales"},
                      {"BALL": "Ballerines"},
                      {"ESP": "Espadrilles"},
                      {"PLATE": "Chaussures plates"},
                      {"BB": "Premiers pas"},
                      {"LACET": "A lacets"},
                      {"CHAUSS": "Chaussons"},
                      {"TOUTC": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTC": "Toutes les chaussures"},
                    {"BAS": "Baskets"},
                    {"BO": "Bottes et bottines"},
                    {"SA": "Sandales"},
                    {"BALL": "Ballerines"},
                    {"ESP": "Espadrilles"},
                    {"PLATE": "Chaussures plates"},
                    {"BB": "Premiers pas"},
                    {"LACET": "A lacets"},
                    {"CHAUSS": "Chaussons"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "C${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Sacs et trousses",
              image: true,
              pathImageHorsmenu: "assets/images/sacs.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTS": "Tout les sacs"},
                      {"SM": "Sacs à main"},
                      {"BB": "Sacs bébé filles"},
                      {"SD": "Sacs à dos"},
                      {"SS": "Sacs de sport"},
                      {"TROU": "Trousses"},
                    ]
                  : const [
                      {"SM": "Sacs à main"},
                      {"BB": "Sacs bébé filles"},
                      {"SD": "Sacs à dos"},
                      {"SS": "Sacs de sport"},
                      {"TROU": "Trousses"},
                      {"TOUTS": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTS": "Tous les sacs"},
                    {"SM": "Sacs à main"},
                    {"BB": "Sacs bébé filles"},
                    {"SD": "Sacs à dos"},
                    {"SS": "Sacs de sport"},
                    {"TROU": "Trousses"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "S${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Accessoires",
              image: true,
              pathImageHorsmenu: "assets/images/acc.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTA": "Tous les accessoires"},
                      {"CHAP": "Chapeaux, bonnets et gants"},
                      {"CHE": "Accessoires pour cheveux"},
                      {"ECH": "Écharpes"},
                      {"LU": "Lunettes de soleil"},
                      {"CO": "Collants"},
                      {"MONTRE": "Montres et bijoux"},
                    ]
                  : const [
                      {"CHAP": "Chapeaux, bonnets et gants"},
                      {"CHE": "Accessoires pour cheveux"},
                      {"ECH": "Écharpes"},
                      {"LU": "Lunettes de soleil"},
                      {"CO": "Collants"},
                      {"MONTRE": "Montres et bijoux"},
                      {"TOUTA": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTA": "Tous les accessoires"},
                    {"CHAP": "Chapeaux, bonnets et gants"},
                    {"CHE": "Accessoires pour cheveux"},
                    {"ECH": "Écharpes"},
                    {"LU": "Lunettes de soleil"},
                    {"CO": "Collants"},
                    {"MONTRE": "Montres et bijoux"},
                  ], selectedKey)!;
                  if (selectedKey == "MONTRE") {
                    categorieForBackend = selectedKey!;
                  } else {
                    categorieForBackend =
                        "A${widget.gender}$selectedKey".toUpperCase();
                  }
                  print(categorieForBackend);
                });
              },
            ),
            
            SizedBox(
              height: 24,
            ),
            CustomButton(
                buttonColor: categorieForBackend == null
                    ? Colors.grey
                    : theme
                        ? Color.fromARGB(255, 249, 217, 144)
                        : Colors.black,
                label: "choisir",
                onTap: categorieForBackend == null
                    ? () {
                        print(categorieForBackend);
                      }
                    : () {
                        print(categorieForBackend);
                        if (widget.isExplore == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation(
                                        category_for_field:
                                            "${widget.genderForFiled} - $for_field",
                                        from_mv: categorieForBackend,
                                        onItemSelected: (int value) {},
                                        currentIndex: 1,
                                      )));
                        } else {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SellProductScreen(
                          //               category_for_field:
                          //                   "${widget.genderForFiled} $for_field",
                          //               categoryFromMv: categorieForBackend,
                          //             )));

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation(
                                        category_for_field:
                                            "${widget.genderForFiled} - $for_field",
                                        from_mv: categorieForBackend,
                                        onItemSelected: (int value) {},
                                        currentIndex: 2,
                                      )));
                        }
                      })
          ],
          if (widget.gender == "g") ...[
            CustomDropdownFormField<String, String>(
              label: "Vétements",
              image: true,
              pathImageHorsmenu: "assets/images/vt.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTV": "Tous les vêtements"},
                      {"VE": "Vestes et Manteaux"},
                      {"MAI": "Mailles"},
                      {"HAUT": "Hauts"},
                      {"TENU": "Tenues"},
                      {"PAN": "Pantalons"},
                      {"SH": "Shorts"},
                      {"BB": "Vêtements Bébé"},
                    ]
                  : const [
                      {"VE": "Vestes et Manteaux"},
                      {"MAI": "Mailles"},
                      {"HAUT": "Hauts"},
                      {"TENU": "Tenues"},
                      {"PAN": "Pantalons"},
                      {"SH": "Shorts"},
                      {"BB": "Vêtements Bébé"},
                      {"TOUTV": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTV": "Tous les vêtements"},
                    {"VE": "Vestes et Manteaux"},
                    {"MAI": "Mailles"},
                    {"HAUT": "Hauts"},
                    {"TENU": "Tenues"},
                    {"PAN": "Pantalons"},
                    {"SH": "Shorts"},
                    {"BB": "Vêtements Bébé"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "V${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Chaussures",
              image: true,
              pathImageHorsmenu: "assets/images/ch.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTC": "Toutes les chaussures"},
                      {"BAS": "Baskets"},
                      {"BO": "Bottes et bottines"},
                      {"SA": "Sandales"},
                      {"BALL": "Ballerines"},
                      {"ESP": "Espadrilles"},
                      {"PLATE": "Chaussures plates"},
                      {"BB": "Premiers pas"},
                      {"LACET": "A lacets"},
                      {"CHAUSS": "Chaussons"},
                    ]
                  : const [
                      {"BAS": "Baskets"},
                      {"BO": "Bottes et bottines"},
                      {"SA": "Sandales"},
                      {"BALL": "Ballerines"},
                      {"ESP": "Espadrilles"},
                      {"PLATE": "Chaussures plates"},
                      {"BB": "Premiers pas"},
                      {"LACET": "A lacets"},
                      {"CHAUSS": "Chaussons"},
                      {"TOUTC": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTC": "Toutes les chaussures"},
                    {"BAS": "Baskets"},
                    {"BO": "Bottes et bottines"},
                    {"SA": "Sandales"},
                    {"BALL": "Ballerines"},
                    {"ESP": "Espadrilles"},
                    {"PLATE": "Chaussures plates"},
                    {"BB": "Premiers pas"},
                    {"LACET": "A lacets"},
                    {"CHAUSS": "Chaussons"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "C${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Sacs et Trousses",
              image: true,
              pathImageHorsmenu: "assets/images/sacs.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTS": "Tous les sacs"},
                      {"BB": "Sacs bébé garçons"},
                      {"SD": "Sacs à dos"},
                      {"SS": "Sacs de sport"},
                      {"TROU": "Trousses"},
                    ]
                  : const [
                      {"BB": "Sacs bébé garçons"},
                      {"SD": "Sacs à dos"},
                      {"SS": "Sacs de sport"},
                      {"TROU": "Trousses"},
                      {"TOUTS": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTS": "Tous les sacs"},
                    {"BB": "Sacs bébé garçons"},
                    {"SD": "Sacs à dos"},
                    {"SS": "Sacs de sport"},
                    {"TROU": "Trousses"},
                  ], selectedKey)!;
                  categorieForBackend =
                      "S${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Accessoires",
              image: true,
              pathImageHorsmenu: "assets/images/acc.jpeg",
              options: widget.isExplore == true
                  ? const [
                      {"TOUTA": "Tous les accessoires"},
                      {"CHAP": "Chapeaux, bonnets et gants"},
                      {"ECH": "Écharpes"},
                      {"LU": "Lunettes de soleil"},
                      {"CE": "Ceintures et bretelles"},
                      {"PAP": "Cravates et nœud de papillon"},
                      {"MONTRE": "Montres et bijoux"},
                    ]
                  : const [
                      {"CHAP": "Chapeaux, bonnets et gants"},
                      {"ECH": "Écharpes"},
                      {"LU": "Lunettes de soleil"},
                      {"CE": "Ceintures et bretelles"},
                      {"PAP": "Cravates et nœud de papillon"},
                      {"MONTRE": "Montres et bijoux"},
                      {"TOUTA": "autres"},
                    ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTA": "Tous les accessoires"},
                    {"CHAP": "Chapeaux, bonnets et gants"},
                    {"ECH": "Écharpes"},
                    {"LU": "Lunettes de soleil"},
                    {"CE": "Ceintures et bretelles"},
                    {"PAP": "Cravates et nœud de papillon"},
                    {"MONTRE": "Montres et bijoux"},
                  ], selectedKey)!;
                  if (selectedKey == "MONTRE") {
                    categorieForBackend = selectedKey!;
                  } else {
                    categorieForBackend =
                        "A${widget.gender}$selectedKey".toUpperCase();
                  }
                  print(categorieForBackend);
                });
              },
            ),
           
            SizedBox(
              height: 24,
            ),
            CustomButton(
                buttonColor: categorieForBackend == null
                    ? Colors.grey
                    : theme
                        ? Color.fromARGB(255, 249, 217, 144)
                        : Colors.black,
                label: "choisir",
                onTap: categorieForBackend == null
                    ? () {
                        print(categorieForBackend);
                      }
                    : () {
                        print(categorieForBackend);
                        if (widget.isExplore == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation(
                                        category_for_field:
                                            "${widget.genderForFiled} - $for_field",
                                        from_mv: categorieForBackend,
                                        onItemSelected: (int value) {},
                                        currentIndex: 1,
                                      )));
                        } else {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SellProductScreen(
                          //               category_for_field:
                          //                   "${widget.genderForFiled} $for_field",
                          //               categoryFromMv: categorieForBackend,
                          //             )));

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation(
                                        category_for_field:
                                            "${widget.genderForFiled} - $for_field",
                                        from_mv: categorieForBackend,
                                        onItemSelected: (int value) {},
                                        currentIndex: 2,
                                      )));
                        }
                      })
          ]
        ],
      ),
    );
  }
}
