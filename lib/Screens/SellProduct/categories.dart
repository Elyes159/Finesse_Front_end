import 'package:finesse_frontend/Screens/SellProduct/SellproductScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/customchekcoptionfield/customchekcoptionfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({super.key});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedSubSubCategory;
  String? selectedValueCategory;
  String? selectedValueSubCategory;
  String? selectedValueSubSubCategory;
  String? CategoryForEnd;
  String? CategoryForBackend;
  String? SubCategoryForBackend;
  String? SubSubCategoryForBackend;
  Map<String, bool> selectedCheckboxes = {
    "Men": false,
    "Women": false,
    "Boys": false,
    "Girls": false,
  };
  String? errorMessage;

  void toggleCheckbox(String key, bool value) {
    setState(() {
      // Mettre à jour la case sélectionnée
      selectedCheckboxes[key] = value;

      // Initialiser SubSubCategoryForBackend si null
      SubSubCategoryForBackend ??= "";

      // Identifier le caractère à ajouter
      String charToAdd = "";
      if (key == "Men") {
        charToAdd = "h";
      } else if (key == "Women") {
        charToAdd = "f";
      } else if (key == "Boys") {
        charToAdd = "g";
      } else if (key == "Girls") {
        charToAdd = "p";
      }

      if (value && SubSubCategoryForBackend != null) {
        // Ajouter le caractère à la deuxième position s'il est absent
        if (!SubSubCategoryForBackend!.contains(charToAdd)) {
          if (SubSubCategoryForBackend!.length < 2) {
            // Si la chaîne est trop courte, ajouter à la fin
            SubSubCategoryForBackend = SubSubCategoryForBackend! + charToAdd;
          } else {
            // Ajouter à la deuxième position
            SubSubCategoryForBackend =
                SubSubCategoryForBackend!.substring(0, 1) +
                    charToAdd +
                    SubSubCategoryForBackend!.substring(1);
          }
        }
      } else if (!value && SubSubCategoryForBackend != null) {
        // Supprimer la première occurrence du caractère s'il existe
        int index = SubSubCategoryForBackend!.indexOf(charToAdd);
        if (index != -1) {
          SubSubCategoryForBackend =
              SubSubCategoryForBackend!.substring(0, index) +
                  SubSubCategoryForBackend!.substring(index + 1);
        }
      }

      errorMessage = null;
    });
    print("oisdhoidjfoiefpoezjf");
    print(SubSubCategoryForBackend);
  }

  bool validateCheckboxSelection() {
    int checkedCount =
        selectedCheckboxes.values.where((isChecked) => isChecked).length;
    return checkedCount == 1; // Exactement une case cochée
  }

  void handleSubmit(bool ismontre) {
    if (selectedCategory == null) {
      setState(() {
        errorMessage = "Veuillez sélectionner une catégorie.";
      });
      return;
    }

    if (selectedCategory == "MV") {
      if (selectedSubCategory == null) {
        setState(() {
          errorMessage = "Veuillez sélectionner une sous-catégorie.";
        });
        return;
      }

      if (!validateCheckboxSelection() && !ismontre) {
        setState(() {
          errorMessage =
              "Veuillez sélectionner exactement un genre (Homme, Femme, Garçon ou Fille).";
        });
        return;
      }
    }

    print("heeeey $SubSubCategoryForBackend , $SubCategoryForBackend , ");
    Navigator.pop(context, {
      'category': selectedCategory?.toUpperCase(),
      'subcategory': selectedSubCategory ?? "",
      'subsubcategory': selectedSubSubCategory ?? "",
      'keyCategory':
          (SubSubCategoryForBackend ?? SubCategoryForBackend)?.toUpperCase(),
      'forBackend': SubSubCategoryForBackend?.toUpperCase(),
    });

    setState(() {
      errorMessage = null;
    });
    print("Category chosen: $selectedCategory");
    print("Sub-category chosen: $selectedSubCategory");
    print("Sub-sub-category chosen: $selectedSubSubCategory");
    print("Checkbox states: $selectedCheckboxes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Text(
              "Choisissez une catégorie",
              style: TextStyle(
                color: Colors.black,
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
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/ArrowLeft.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(
            width: 343,
            child: Text(
              "Sélectionnez une catégorie pour votre article dans la liste ci-dessous",
              style: TextStyle(
                color: Color(0xFF334155),
                fontSize: 14,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if ((selectedCategory == "D" || selectedCategory == null)) ...[
            const SizedBox(height: 24),
            CustomDropdownFormField<String, String>(
              label: "Decoration",
              options: const [
                {"DECOMU": "Décoration murale"},
                {"PLVA": "Plantes, vases"},
                {"LUMI": "Luminaires"},
                {"OBDEC": "Objets déco "},
                {"RAN": "Rangements"},
                {"BGS": "Bougies,senteurs"},
                {"TAP": "Tapis"},
                {"LINM": "Linge de maison"},
                {"DECOAUT": "Autres"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  selectedCategory = "D";
                  CategoryForBackend = "D";
                  SubCategoryForBackend = selectedKey;

                  print("$CategoryForBackend $SubCategoryForBackend");
                  // Mettre la catégorie principale sur "Mode et Vintage"
                  selectedSubCategory =
                      selectedKey; // Mettre la sous-catégorie avec la clé sélectionnée
                  errorMessage = null; // Réinitialiser le message d'erreur
                });
              },
              selectedKey:
                  selectedSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
            ),
          ],
          if ((selectedCategory == "L" || selectedCategory == null)) ...[
            const SizedBox(height: 24),
            CustomDropdownFormField<String, String>(
              label: "Livres",
              options: const [
                {"L": "Livre"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  selectedCategory = "L";
                  CategoryForBackend = "L";
                  SubCategoryForBackend = selectedKey;

                  print("$CategoryForBackend $SubCategoryForBackend");
                  // Mettre la catégorie principale sur "Mode et Vintage"
                  selectedSubCategory =
                      selectedKey; // Mettre la sous-catégorie avec la clé sélectionnée
                  errorMessage = null; // Réinitialiser le message d'erreur
                });
              },
              selectedKey:
                  selectedSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
            ),
          ],
          if ((selectedCategory == "AC" || selectedCategory == null)) ...[
            const SizedBox(height: 24),
            CustomDropdownFormField<String, String>(
              label: "Art et création",
              options: const [
                {"PEIN": "Peinture"},
                {"SCUL": "Sculpture"},
                {"LITE": "Literature"},
                {"tableaux": "Tableaux de peintures"},
                {"ARTGRAPH": "Arts graphiques"},
                {"ARTTABLE": "Arts de la table"},
                {"ARTAUT": "Autres"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  CategoryForBackend = "AC";
                  SubCategoryForBackend = selectedKey;
                  selectedCategory = "AC";
                  selectedSubCategory = selectedKey;
                  errorMessage = null;
                });
              },
              selectedKey:
                  selectedSubCategory, // Assurez-vous que cette valeur est correcte
            ),
          ],
          if (selectedSubCategory == "PEIN") ...[
            const SizedBox(height: 12),
            CustomDropdownFormField<String, String>(
              label: "Sub-category of Peinture",
              options: const [
                {"ACRY": "Peinture acrylique"},
                {"AQ": "Peinture aquarelle"},
                {"CUB": "Cubisme"},
                {"EXPRE": "Expressionnisme"},
                {"ARTABS": "Art abstrait"},
                {"PH": "Peinture à l'huile"},
                {"AUT": "Autre"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  SubSubCategoryForBackend = SubCategoryForBackend;
                  SubSubCategoryForBackend =
                      "$SubCategoryForBackend$selectedKey";
                  print(SubSubCategoryForBackend);
                  selectedSubSubCategory = selectedKey;
                });
              },
              selectedKey:
                  selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
            ),
          ],
          if ((selectedCategory == "MV" || selectedCategory == null)) ...[
            const SizedBox(height: 24),
            CustomDropdownFormField<String, String>(
              label: "Mode and vintage",
              options: const [
                {"V": "Vêtements"},
                {"C": "Chaussures"},
                {"B": "Bijoux"},
                {"A": "Accessoires"},
                {"S": "Sacs"},
                {"P": "Produits de beauté"},
                {"J": "Jouets"},
                {"MONTRE": "Montres"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  CategoryForBackend = "MV";
                  SubCategoryForBackend = selectedKey;
                  print("$CategoryForBackend $SubCategoryForBackend");
                  selectedCategory = "MV";
                  selectedSubCategory = selectedKey;
                  errorMessage = null;
                  if (selectedSubCategory == "MONTRE") {}
                });
              },

              selectedKey:
                  selectedSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
            ),
          ],
          if (selectedCategory == "MV") ...[
            if (selectedSubCategory == "J") ...[
              const SizedBox(height: 12),
              CustomDropdownFormField<String, String>(
                label: "Sub-category of Jouets",
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
                    SubSubCategoryForBackend = SubCategoryForBackend;
                    SubSubCategoryForBackend =
                        "$SubSubCategoryForBackend$selectedKey";
                    print(SubSubCategoryForBackend);
                    selectedSubSubCategory =
                        selectedKey; // Mise à jour de la sous-catégorie
                  });
                },
                selectedKey:
                    selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
              ),
            ],
            if (selectedSubCategory == "MONTRE") ...[],
            if (selectedSubCategory == "P") ...[
              const SizedBox(height: 12),
              CustomDropdownFormField<String, String>(
                label: "Sub-category of Produit de beauté",
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
                    SubSubCategoryForBackend = SubCategoryForBackend;
                    SubSubCategoryForBackend =
                        "$SubSubCategoryForBackend$selectedKey";
                    print(SubSubCategoryForBackend);
                    selectedSubSubCategory =
                        selectedKey; // Mise à jour de la sous-catégorie
                  });
                },
                selectedKey:
                    selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
              ),
            ],
            if (selectedSubCategory == "S") ...[
              const SizedBox(height: 12),
              CustomDropdownFormField<String, String>(
                label: "Sub-category of Sacs",
                options: const [
                  {"SM": "Sac à main"},
                  {"BAND": "Sac à bandoulière"},
                  {"P": "Pochette"},
                  {"SD": "Sac à dos"},
                  {"COU": "Couffin"},
                  {"PORT": "Portefeuille"},
                  {"PORTM": "Porte-monnaie"},
                  {"CA": "Cartable"},
                  {"BB": "Sac bébé"},
                  {"EC": "Étui à crayon"},
                  {"SS": "Sac de sport"},
                ],
                onChanged: (selectedKey) {
                  setState(() {
                    SubSubCategoryForBackend = SubCategoryForBackend;
                    SubSubCategoryForBackend =
                        "$SubSubCategoryForBackend$selectedKey";
                    print(SubSubCategoryForBackend);
                    selectedSubSubCategory =
                        selectedKey; // Mise à jour de la sous-catégorie
                  });
                },
                selectedKey:
                    selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
              ),
            ],
            if (selectedSubCategory == "A") ...[
              const SizedBox(height: 12),
              CustomDropdownFormField<String, String>(
                label: "Sub-category of Accessoires",
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
                  {"CR": "Cravate"},
                  {"PAP": "Nœud de papillon"},
                ],
                onChanged: (selectedKey) {
                  setState(() {
                    SubSubCategoryForBackend = SubCategoryForBackend;
                    SubSubCategoryForBackend =
                        "$SubSubCategoryForBackend$selectedKey";
                    print(SubSubCategoryForBackend);
                    selectedSubSubCategory =
                        selectedKey; // Mise à jour de la sous-catégorie
                  });
                },
                selectedKey:
                    selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
              ),
            ],
            if (selectedSubCategory == "B") ...[
              const SizedBox(height: 12),
              CustomDropdownFormField<String, String>(
                label: "Sub-category of Bijoux",
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
                    SubSubCategoryForBackend = SubCategoryForBackend;
                    SubSubCategoryForBackend =
                        "$SubSubCategoryForBackend$selectedKey";
                    print(SubSubCategoryForBackend);
                    selectedSubSubCategory =
                        selectedKey; // Mise à jour de la sous-catégorie
                  });
                },
                selectedKey:
                    selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
              ),
            ],
            if (selectedSubCategory == "C") ...[
              const SizedBox(height: 12),
              CustomDropdownFormField<String, String>(
                label: "Sub-category of Chaussures",
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
                  {"BB": "Bébé"},
                  {"CHAUSS": "Chaussons"},
                  {"MO": "Mocassins"},
                ],
                onChanged: (selectedKey) {
                  setState(() {
                    SubSubCategoryForBackend = SubCategoryForBackend;
                    SubSubCategoryForBackend =
                        "$SubSubCategoryForBackend$selectedKey";
                    print(SubSubCategoryForBackend);
                    selectedSubSubCategory =
                        selectedKey; // Mise à jour de la sous-catégorie
                  });
                },
                selectedKey:
                    selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
              ),
            ],
            if (selectedSubCategory == "V") ...[
              const SizedBox(height: 12),
              CustomDropdownFormField<String, String>(
                label: "Sub-category of Vêtements",
                options: const [
                  {"BB": "Vêtements Bébé"},
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
                    SubSubCategoryForBackend = SubCategoryForBackend;
                    SubSubCategoryForBackend =
                        "$SubSubCategoryForBackend$selectedKey";
                    print(SubSubCategoryForBackend);
                    selectedSubSubCategory =
                        selectedKey; // Mise à jour de la sous-catégorie
                  });
                },
                selectedKey:
                    selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
              ),
            ],
          ],
          if (selectedCategory == "MV" &&
              {"S", "A", "C", "V"}.contains(selectedSubCategory) &&
              {
                "CH",
                "PU",
                "PAN",
                "PY",
                "MAI",
                "CE",
                "CHAP",
                "ECH",
                "LU",
                "SM",
                "SD",
                "CA",
                "BAS",
                "BO",
                "SA"
              }.contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Homme",
              initialValue: selectedCheckboxes["Men"]!,
              onChanged: (newValue) {
                toggleCheckbox("Men", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Femme",
              initialValue: selectedCheckboxes["Women"]!,
              onChanged: (newValue) {
                toggleCheckbox("Women", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Garçon",
              initialValue: selectedCheckboxes["Boys"]!,
              onChanged: (newValue) {
                toggleCheckbox("Boys", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Fille",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) {
                toggleCheckbox("Girls", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"S", "A", "C", "V"}.contains(selectedSubCategory) &&
              {"RO", "JU", "CHE", "CO", "BALL"}
                  .contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Femmme",
              initialValue: selectedCheckboxes["Women"]!,
              onChanged: (newValue) {
                toggleCheckbox("Women", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Fille",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) {
                toggleCheckbox("Girls", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"S", "A", "C", "V"}.contains(selectedSubCategory) &&
              {
                "T-S",
                "CAF",
                "GI",
                "VE",
                "MAN",
                "TR",
                "PAC",
                "SH",
                "SALO",
                "LIN",
                "KIM",
                "COM",
                "SARI",
                "ENS",
                "CHAUSS",
                "BONN",
                "FOU",
                "BAND",
                "P",
                "COU",
                "PORT",
                "PORTM",
                "BOTI",
                "ESC",
                "COMP",
                "ESP",
                "S-O",
                "MU",
                "DER"
              }.contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Femme",
              initialValue: selectedCheckboxes["Women"]!, // Par défaut cochée
              onChanged: (newValue) {
                toggleCheckbox("Women", newValue);
              }, // Désactiver l'interaction utilisateur
            ),
          ],
          if (selectedCategory == "MV" &&
              {"S", "A", "C", "V"}.contains(selectedSubCategory) &&
              {"CR", "PAP", "COS", "SS", "MO"}
                  .contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Garçons",
              initialValue: selectedCheckboxes["Boys"]!,
              onChanged: (newValue) {
                toggleCheckbox("Boys", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Homme",
              initialValue: selectedCheckboxes["Men"]!,
              onChanged: (newValue) {
                toggleCheckbox("Men", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"S", "A", "C", "V"}.contains(selectedSubCategory) &&
              {"S-V", "EC", "BB", "CHAUSS"}
                  .contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Garçons",
              initialValue: selectedCheckboxes["Boys"]!,
              onChanged: (newValue) {
                toggleCheckbox("Boys", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Fille",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) {
                toggleCheckbox("Girls", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"S", "A", "C", "V"}.contains(selectedSubCategory) &&
              {"BI"}.contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Fille",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) {
                toggleCheckbox("Girls", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"S", "A", "C", "V"}.contains(selectedSubCategory) &&
              {"EX"}.contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Garçons",
              initialValue: selectedCheckboxes["Boys"]!,
              onChanged: (newValue) {
                toggleCheckbox("Boys", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Homme",
              initialValue: selectedCheckboxes["Men"]!,
              onChanged: (newValue) {
                toggleCheckbox("Men", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Fille",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) {
                toggleCheckbox("Girls", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"B"}.contains(selectedSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Femme",
              initialValue: true, // Par défaut cochée
              onChanged: (newValue) {
                toggleCheckbox("Women", newValue);
              }, // Désactiver l'interaction utilisateur
            ),
          ],
          if (selectedCategory == "MV" &&
              {"J"}.contains(selectedSubCategory) &&
              {"DO", "JE", "PA", "PE", "PU", "TRO", "VHE"}
                  .contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Hommes",
              initialValue: selectedCheckboxes["Boys"]!,
              onChanged: (newValue) {
                toggleCheckbox("Boys", newValue);
              },
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Fille",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) {
                toggleCheckbox("Girls", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"J"}.contains(selectedSubCategory) &&
              {"BA"}.contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Garçons",
              initialValue: selectedCheckboxes["Boys"]!,
              onChanged: (newValue) {
                toggleCheckbox("Boys", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"J"}.contains(selectedSubCategory) &&
              {"POU"}.contains(selectedSubSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Filles",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) {
                toggleCheckbox("Girls", newValue);
              },
            ),
          ],
          if (selectedCategory == "MV" &&
              {"P"}.contains(selectedSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Femmes",
              initialValue: selectedCheckboxes["Women"]!, // Par défaut cochée
              onChanged: (newValue) {
                toggleCheckbox("Women", newValue);
              }, // Désactiver l'interaction utilisateur
            ),
          ],
          const SizedBox(height: 24),
          if (errorMessage != null) ...[
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontFamily: "Raleway",
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
          ],
          CustomButton(
            label: "Choisir une catégorie",
            onTap: () {
              handleSubmit(selectedSubCategory == "MONTRE");
            },
            isDisabled: selectedSubCategory == "MONTRE"
                ? false
                : selectedCategory == null ||
                    (selectedCategory == "MV" &&
                        (selectedSubCategory == null &&
                                selectedSubSubCategory == null ||
                            !validateCheckboxSelection())) ||
                    (selectedCategory == "AC" &&
                        selectedSubCategory == "PEIN" &&
                        (selectedSubCategory == null ||
                            selectedSubSubCategory == null &&
                                !validateCheckboxSelection())),
          ),
          SizedBox(
            width: 343,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontSize: 14,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Ou vous pouvez ", // Partie du texte non stylisée
                  ),
                  TextSpan(
                    text:
                        "Réinitialiser", // Mot à colorier en rose et rendre interactif
                    style: const TextStyle(
                      color: Color(0xFFFB98B7), // Couleur rose
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          selectedCategory = null;
                          selectedSubCategory = null;
                          selectedSubSubCategory = null;
                          CategoryForEnd = null;
                          CategoryForBackend = null;
                          SubCategoryForBackend = null;
                          SubSubCategoryForBackend = null;
                          selectedCheckboxes = {
                            "Men": false,
                            "Women": false,
                            "Boys": false,
                            "Girls": false,
                          };
                        });
                        print("Reset clicked");
                      },
                  ),
                  TextSpan(
                    text: ' votre choix', // Partie du texte non stylisée
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
