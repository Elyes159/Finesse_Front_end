import 'package:finesse_frontend/Screens/HomeScreens/Explore.dart';
import 'package:finesse_frontend/Screens/SellProduct/SellproductScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:flutter/material.dart';

class BChoice extends StatefulWidget {
  final bool? isExplore;
  const BChoice({super.key, required this.gender, this.isExplore});
  final String gender;
  @override
  State<BChoice> createState() => _BChoiceState();
}

class _BChoiceState extends State<BChoice> {
  String? categorieForBackend;
  @override
  Widget build(BuildContext context) {
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
              options: const [
                //{"BB": "Vêtements Bébé"},
                {"EX": "Vêtements d'exterieur"},
                //{"RO": "Robe"},
                //{"CAF": "Caftan"},
                {"T-S": "T-Shirt"},
                {"PU": "Pull"},
                {"CH": "Chemise"},
                {"GI": "Gilet"},
                {"VE": "Veste"},
                {"MAN": "Manteau"},
                //{"TR": "Trench"},
                {"PAN": "Pantalon"},
                {"PAC": "Pantacourt"},
                {"SH": "Short"},
                //{"SALO": "Salopette"},
                // {"JU": "Jupe"},
                {"MAI": "Maillot"},
                //{"LIN": "Lingerie"},
                {"PY": "Pyjamas"},
                //{"KIM": "Kimono"},
                //{"COM": "Combinaison"},
                //{"SARI": "Sari"},
                {"ENS": "Ensemble"},
                {"S-V": "sous vêtements"},
                {"COS": "Costumes"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"BO": "Bottes"},
                //{"BOTI": "Bottines"},
                //{"ESC": "Escarpins"},
                {"COMP": "Compensés"},
                {"SA": "Sandales"},
                {"BAS": "Baskets"},
                {"ESP": "Espadrilles"},
                //{"S-O": "Slip-on"},
                //{"BALL": "Ballerines"},
                //{"MU": "Mules"},
                //{"DER": "Derbies"},
                //{"BB": "Bébé"},
                {"CHAUSS": "Chaussons"},
                {"MO": "Mocassins"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                //{"SM": "Sac à main"},
                //{"BAND": "Sac à bandoulière"},
                //{"P": "Pochette"},
                {"SD": "Sac à dos"},
                //{"COU": "Couffin"},
                {"PORT": "Portefeuille"},
                {"PORTM": "Porte-monnaie"},
                {"CA": "Cartable"},
                //{"BB": "Sac bébé"},
                //{"EC": "Étui à crayon"},
                {"SS": "Sac de sport"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"LU": "Lunette"},
                {"CE": "Ceinture"},
                //{"CHE": "Accessoires pour cheveux"},
                //{"CO": "Collant"},
                //{"CHAUSS": "Chaussette"},
                {"CHAP": "Chapeau"},
                {"BONN": "Bonnet"},
                {"ECH": "Écharpe"},
                //{"FOU": "Foulard"},
                //{"BI": "Bijoux"},
                {"CR": "Cravate"},
                {"PAP": "Nœud de papillon"},
                {"MONTRE": "MONTRE"}
              ],
              onChanged: (selectedKey) {
                print("onChanged déclenché avec : $selectedKey");
                setState(() {
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
                    : Color.fromARGB(255, 249, 217, 144),
                label: "choisir",
                onTap: categorieForBackend == null
                    ? () {
                        print(categorieForBackend);
                      }
                    : () {
                        print(categorieForBackend);
                        if(widget.isExplore==true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Explore(
                                      from_mv:categorieForBackend ,
                                    )));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellProductScreen(
                                      categoryFromMv: categorieForBackend,
                                    )));
                        }
                      })
          ],
          if (widget.gender == "f") ...[
            CustomDropdownFormField<String, String>(
              label: "Vétements",
              image: true,
              pathImageHorsmenu: "assets/images/vt.jpeg",
              options: const [
                {"EX": "Vêtements d'exterieur"},
                {"RO": "Robe"},
                {"CAF": "Caftan"},
                {"T-S": "T-Shirt"},
                {"PU": "Pull"},
                {"CH": "Chemise"},
                {"GI": "Gilet"},
                {"VE": "Veste"},
                {"MAN": "Manteau"},
                {"TR": "Trench"},
                {"PAN": "Pantalon"},
                {"PAC": "Pantacourt"},
                {"SH": "Short"},
                {"SALO": "Salopette"},
                {"JU": "Jupe"},
                {"MAI": "Maillot"},
                {"LIN": "Lingerie"},
                {"PY": "Pyjamas"},
                {"KIM": "Kimono"},
                {"COM": "Combinaison"},
                {"SARI": "Sari"},
                {"ENS": "Ensemble"},
                {"S-V": "sous vêtements"},
                {"COS": "Costumes"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              label: "Produits de beauté",
              image: true,
              pathImageHorsmenu: "assets/images/pb.jpeg",
              options: const [
                {"PF": "Parfum"},
                {"SV": "Soins visage"},
                {"SC": "Soins corps"},
                {"SCH": "Soins cheveux"},
                {"SM": "Soins mains"},
                {"DOU": "Douche"},
                {"MAQUI": "Maquillage"},
                {"VER": "Vernis"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  categorieForBackend =
                      "P${widget.gender}$selectedKey".toUpperCase();
                  print(categorieForBackend);
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Bijoux",
              image: true,
              pathImageHorsmenu: "assets/images/bj.jpeg",
              options: const [
                {"C": "Collier"},
                {"B": "Bracelet"},
                {"BO": "Boucles d'oreilles"},
                {"BAG": "Bague"},
                {"MO": "Montre"},
                {"PAR": "Parure"},
                {"PIER": "Piercing"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  categorieForBackend =
                      "B${widget.gender}$selectedKey".toUpperCase();
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
              options: const [
                {"BO": "Bottes"},
                {"BOTI": "Bottines"},
                {"ESC": "Escarpins"},
                {"COMP": "Compensés"},
                {"SA": "Sandales"},
                {"BAS": "Baskets"},
                {"ESP": "Espadrilles"},
                {"S-O": "Slip-on"},
                {"BALL": "Ballerines"},
                {"MU": "Mules"},
                {"DER": "Derbies"},
                //{"BB": "Bébé"},
                {"CHAUSS": "Chaussons"},
                //{"MO": "Mocassins"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"SM": "Sac à main"},
                {"BAND": "Sac à bandoulière"},
                {"P": "Pochette"},
                {"SD": "Sac à dos"},
                {"COU": "Couffin"},
                {"PORT": "Portefeuille"},
                {"PORTM": "Porte-monnaie"},
                {"CA": "Cartable"},
                //{"BB": "Sac bébé"},
                //{"EC": "Étui à crayon"},
                {"SS": "Sac de sport"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"LU": "Lunette"},
                {"CE": "Ceinture"},
                {"CHE": "Accessoires pour cheveux"},
                {"CO": "Collant"},
                {"CHAUSS": "Chaussette"},
                {"CHAP": "Chapeau"},
                {"BONN": "Bonnet"},
                {"ECH": "Écharpe"},
                {"FOU": "Foulard"},
                {"BI": "Bijoux"},
                {"MONTRE": "MONTRE"}
                //{"CR": "Cravate"},
                //{"PAP": "Nœud de papillon"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
                    : Color.fromARGB(255, 249, 217, 144),
                label: "choisir",
                onTap: categorieForBackend == null
                    ? () {
                        print(categorieForBackend);
                      }
                    : () {
                        print(categorieForBackend);
                       if(widget.isExplore==true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Explore(
                                      from_mv:categorieForBackend ,
                                    )));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellProductScreen(
                                      categoryFromMv: categorieForBackend,
                                    )));
                        }
                      })
          ],
          if (widget.gender == "p") ...[
            CustomDropdownFormField<String, String>(
              label: "Vétements",
              image: true,
              pathImageHorsmenu: "assets/images/vt.jpeg",
              options: const [
                {"BB": "Vêtements Bébé"},
                {"EX": "Vêtements d'exterieur"},
                {"RO": "Robe"},
                {"CAF": "Caftan"},
                {"T-S": "T-Shirt"},
                {"PU": "Pull"},
                //{"CH": "Chemise"},
                {"GI": "Gilet"},
                {"VE": "Veste"},
                {"MAN": "Manteau"},
                {"TR": "Trench"},
                {"PAN": "Pantalon"},
                {"PAC": "Pantacourt"},
                {"SH": "Short"},
                {"SALO": "Salopette"},
                {"JU": "Jupe"},
                {"MAI": "Maillot"},
                {"LIN": "Lingerie"},
                {"PY": "Pyjamas"},
                {"KIM": "Kimono"},
                {"COM": "Combinaison"},
                {"SARI": "Sari"},
                {"ENS": "Ensemble"},
                {"S-V": "sous vêtements"},
                //{"COS": "Costumes"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"BO": "Bottes"},
                {"BOTI": "Bottines"},
                //{"ESC": "Escarpins"},
                {"COMP": "Compensés"},
                {"SA": "Sandales"},
                {"BAS": "Baskets"},
                {"ESP": "Espadrilles"},
                {"S-O": "Slip-on"},
                {"BALL": "Ballerines"},
                {"MU": "Mules"},
                {"DER": "Derbies"},
                {"BB": "Bébé"},
                {"CHAUSS": "Chaussons"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"SM": "Sac à main"},
                //{"BAND": "Sac à bandoulière"},
                //{"P": "Pochette"},
                {"SD": "Sac à dos"},
                //{"COU": "Couffin"},
                //{"PORT": "Portefeuille"},
                //{"PORTM": "Porte-monnaie"},
                {"CA": "Cartable"},
                {"BB": "Sac bébé"},
                {"EC": "Étui à crayon"},
                //{"SS": "Sac de sport"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"LU": "Lunette"},
                //{"CE": "Ceinture"},
                {"CHE": "Accessoires pour cheveux"},
                {"CO": "Collant"},
                {"CHAUSS": "Chaussette"},
                {"CHAP": "Chapeau"},
                {"ECH": "Écharpe"},
                //{"FOU": "Foulard"},
                {"BI": "Bijoux"},
                //{"CR": "Cravate"},
                //{"PAP": "Nœud de papillon"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Jouets",
              image: true,
              pathImageHorsmenu: "assets/images/jouets.jpeg",
              options: const [
                {"BA": "Ballons"},
                {"DO": "Dominos"},
                {"JE": "Jeux éducatifs"},
                {"PA": "Patins"},
                {"PE": "Peluches"},
                {"PU": "Puzzles"},
                {"TRO": "Trottinettes"},
                {"VHE": "Véhicules"},
                {"POU": "Poupées"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  categorieForBackend =
                      "J${widget.gender}$selectedKey".toUpperCase();
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
                    : Color.fromARGB(255, 249, 217, 144),
                label: "choisir",
                onTap: categorieForBackend == null
                    ? () {
                        print(categorieForBackend);
                      }
                    : () {
                        print(categorieForBackend);
                       if(widget.isExplore==true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Explore(
                                      from_mv:categorieForBackend ,
                                    )));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellProductScreen(
                                      categoryFromMv: categorieForBackend,
                                    )));
                        }
                      })
          ],
          if (widget.gender == "g") ...[
            CustomDropdownFormField<String, String>(
              label: "Vétements",
              image: true,
              pathImageHorsmenu: "assets/images/vt.jpeg",
              options: const [
                {"BB": "Vêtements Bébé"},
                {"EX": "Vêtements d'exterieur"},
                //{"RO": "Robe"},
                //{"CAF": "Caftan"},
                {"T-S": "T-Shirt"},
                {"PU": "Pull"},
                {"CH": "Chemise"},
                {"GI": "Gilet"},
                {"VE": "Veste"},
                {"MAN": "Manteau"},
                //{"TR": "Trench"},
                {"PAN": "Pantalon"},
                {"PAC": "Pantacourt"},
                {"SH": "Short"},
                //{"SALO": "Salopette"},
                // {"JU": "Jupe"},
                {"MAI": "Maillot"},
                //{"LIN": "Lingerie"},
                {"PY": "Pyjamas"},
                //{"KIM": "Kimono"},
                //{"COM": "Combinaison"},
                //{"SARI": "Sari"},
                {"ENS": "Ensemble"},
                {"S-V": "sous vêtements"},
                {"COS": "Costumes"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"BO": "Bottes"},
                //{"BOTI": "Bottines"},
                //{"ESC": "Escarpins"},
                {"COMP": "Compensés"},
                {"SA": "Sandales"},
                {"BAS": "Baskets"},
                {"ESP": "Espadrilles"},
                //{"S-O": "Slip-on"},
                //{"BALL": "Ballerines"},
                //{"MU": "Mules"},
                //{"DER": "Derbies"},
                {"BB": "Bébé"},
                {"CHAUSS": "Chaussons"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"SM": "Sac à main"},
                //{"BAND": "Sac à bandoulière"},
                //{"P": "Pochette"},
                {"SD": "Sac à dos"},
                //{"COU": "Couffin"},
                //{"PORT": "Portefeuille"},
                //{"PORTM": "Porte-monnaie"},
                {"CA": "Cartable"},
                {"BB": "Sac bébé"},
                {"EC": "Étui à crayon"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              options: const [
                {"LU": "Lunette"},
                {"CE": "Ceinture"},
                //{"CHE": "Accessoires pour cheveux"},
                {"CO": "Collant"},
                {"CHAUSS": "Chaussette"},
                {"CHAP": "Chapeau"},
                {"ECH": "Écharpe"},
                //{"FOU": "Foulard"},
                //{"BI": "Bijoux"},
                {"CR": "Cravate"},
                {"PAP": "Nœud de papillon"},
                {"MONTRE": "Montres"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
              height: 16,
            ),
            CustomDropdownFormField<String, String>(
              label: "Jouets",
              image: true,
              pathImageHorsmenu: "assets/images/jouets.jpeg",
              options: const [
                {"BA": "Ballons"},
                {"DO": "Dominos"},
                {"JE": "Jeux éducatifs"},
                //{"PA": "Patins"},
                //{"PE": "Peluches"},
                {"PU": "Puzzles"},
                {"TRO": "Trottinettes"},
                {"VHE": "Véhicules"},
                //{"POU": "Poupées"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  categorieForBackend =
                      "J${widget.gender}$selectedKey".toUpperCase();
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
                    : Color.fromARGB(255, 249, 217, 144),
                label: "choisir",
                onTap: categorieForBackend == null
                    ? () {
                        print(categorieForBackend);
                      }
                    : () {
                        print(categorieForBackend);
                        if(widget.isExplore==true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Explore(
                                      from_mv:categorieForBackend ,
                                    )));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellProductScreen(
                                      categoryFromMv: categorieForBackend,
                                    )));
                        }
                      })
          ]
        ],
      ),
    );
  }
}
