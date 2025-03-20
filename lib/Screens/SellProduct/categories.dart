import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/SellProduct/SellproductScreen.dart';
import 'package:finesse_frontend/Screens/SellProduct/agender.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/customchekcoptionfield/customchekcoptionfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChooseCategory extends StatefulWidget {
  final bool? isExplore;
  const ChooseCategory({super.key, this.isExplore = false});

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
  String? for_field;
  Map<String, bool> selectedCheckboxes = {
    "Men": false,
    "Women": false,
    "Boys": false,
    "Girls": false,
  };
  String? errorMessage;
  String? getSelectedValue(List<Map<String, String>> options, String? key) {
    for (var option in options) {
      if (option.containsKey(key)) {
        return option[key];
      }
    }
    return null; // Retourne null si la clé n'existe pas
  }

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
    }

    print("heeeey $SubSubCategoryForBackend , $SubCategoryForBackend , ");
    Navigator.pop(context, {
      'explore': widget.isExplore == true
          ? SubSubCategoryForBackend ?? SubCategoryForBackend
          : null,
      'category': selectedCategory?.toUpperCase(),
      'subcategory': selectedSubCategory ?? "",
      'subsubcategory': selectedSubSubCategory ?? "",
      'keyCategory':
          (SubSubCategoryForBackend ?? SubCategoryForBackend)?.toUpperCase(),
      'forBackend': SubSubCategoryForBackend?.toUpperCase(),
      'for_field': for_field,
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
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (selectedCategory == null) {
              Navigator.pop(context);
            } else {
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
            }
          },
        ),
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
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            width: 343,
            child: Text(
              widget.isExplore == true
                  ? ""
                  : "Sélectionnez une catégorie pour votre article dans la liste ci-dessous",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if ((selectedCategory == null)) ...[
            const SizedBox(height: 24),
            CustomDropdownFormField<String, String>(
              image: true,
              pathImageHorsmenu: "assets/images/ov.jpeg",
              label: "œuvres d’art",
              options: widget.isExplore ==true? const [
                {"TOEU": "Toutes les œuvres "},
                {"tableaux": "Tableaux "},
                {"ARTGRAPH": "Arts graphiques"},
                {"SCUL": "Sculptures "},
                {"L": "Livres "},
              ] :const [
                
                {"tableaux": "Tableaux "},
                {"ARTGRAPH": "Arts graphiques"},
                {"SCUL": "Sculptures "},
                {"L": "Livres "},
                {"TOEU": "autres "},
              ] ,
              onChanged: (selectedKey) {
                setState(() {
                  CategoryForBackend = "OV";
                  if (selectedKey == "L") {
                    selectedCategory = "L";
                  } else {
                    selectedCategory = "OV";
                  }
                  SubCategoryForBackend = selectedKey;
                  for_field = getSelectedValue([
                    {"TOEU": "Toutes les œuvres "},
                    {"tableaux": "Tableaux "},
                    {"ARTGRAPH": "Arts graphiques"},
                    {"SCUL": "Sculptures "},
                    {"L": "Livres "},
                  ], selectedKey);
                  selectedSubCategory = selectedKey;
                  errorMessage = null;
                });
              },
              selectedKey:
                  selectedSubCategory, // Assurez-vous que cette valeur est correcte
            ),
          ],
          if ((selectedCategory == null)) ...[
            const SizedBox(height: 24),
            CustomDropdownFormField<String, String>(
              image: true,
              pathImageHorsmenu: "assets/images/cra.jpeg",
              label: "Creations artisanales",
              options: widget.isExplore ==true ? const [
                {"TCREA": "Toutes les créations "},
                {"CERAPO": "Céramique et poterie "},
                {"HAUCO": "Haute couture"},
                {"MACRA": "Macramé"},
                {"BIJOUX": "Bijoux"},
                {"SACOU": "Sacs et couffins"},
                {"TAPI": "Tapis"},
              ] : const [
                {"CERAPO": "Céramique et poterie "},
                {"HAUCO": "Haute couture"},
                {"MACRA": "Macramé  "},
                {"BIJOUX": "Bijoux  "},
                {"SACOU": "Sacs et couffins  "},
                {"TAPI": "Tapis  "},
                {"TCREA": "autres "},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  CategoryForBackend = "CRA";
                  selectedCategory = "CRA";
                  SubCategoryForBackend = selectedKey;
                  for_field = getSelectedValue([
                    {"TCREA": "Toutes les créations "},
                    {"CERAPO": "Céramique et poterie "},
                    {"HAUCO": "Haute couture"},
                    {"MACRA": "Macramé  "},
                    {"BIJOUX": "Bijoux  "},
                    {"SACOU": "Sacs et couffins  "},
                    {"TAPI": "Tapis  "},
                  ], selectedKey);
                  selectedSubCategory = selectedKey;
                  errorMessage = null;
                });
              },
              selectedKey:
                  selectedSubCategory, // Assurez-vous que cette valeur est correcte
            ),
          ],
          if ((selectedCategory == null)) ...[
            const SizedBox(height: 24),
            CustomDropdownFormField<String, String>(
              label: "Décorations",
              image: true,
              pathImageHorsmenu: "assets/images/deco.jpeg",
              options: widget.isExplore ==true? const [
                {"TOUTD": "Toutes les décorations"},
                {"DECOMU": "Décorations murales"},
                {"PLVA": "Plantes, vases"},
                {"LUMI": "Luminaires"},
                {"OBDEC": "Objets déco "},
                {"RAN": "Rangements"},
                {"BGS": "Bougies,senteurs"},
                {"TAP": "Tapis"},
                {"LINM": "Linges de maison"},
              ] : const [ 
                {"DECOMU": "Décorations murales"},
                {"PLVA": "Plantes, vases"},
                {"LUMI": "Luminaires"},
                {"OBDEC": "Objets déco "},
                {"RAN": "Rangements"},
                {"BGS": "Bougies,senteurs"},
                {"TAP": "Tapis"},
                {"LINM": "Linges de maison"},
                {"TOUTD": "autres"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTD": "Toutes les Décoration"},
                    {"DECOMU": "Décorations murales"},
                    {"PLVA": "Plantes, vases"},
                    {"LUMI": "Luminaires"},
                    {"OBDEC": "Objets déco "},
                    {"RAN": "Rangements"},
                    {"BGS": "Bougies,senteurs"},
                    {"TAP": "Tapis"},
                    {"LINM": "Linges de maison"},
                  ], selectedKey);
                  print(for_field);
                  selectedCategory = "D";
                  CategoryForBackend = "D";
                  SubCategoryForBackend = selectedKey;
                  for_field = getSelectedValue([
                    {"DECOMU": "Décorations murales"},
                    {"PLVA": "Plantes, vases"},
                    {"LUMI": "Luminaires"},
                    {"OBDEC": "Objets déco "},
                    {"RAN": "Rangements"},
                    {"BGS": "Bougies,senteurs"},
                    {"TAP": "Tapis"},
                    {"LINM": "Linges de maison"},
                  ], selectedKey);
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
          if ((selectedCategory == "L")) ...[
            const SizedBox(height: 24),
            CustomDropdownFormField<String, String>(
              image: true,
              pathImageHorsmenu: "assets/images/livre.jpeg",
              label: "Livres",
             
              options: widget.isExplore ==true ? const [
                 {"TOUTL": "Tout les livres"},
                {"LLIT": "Littérature"},
                {"LROM": "Romans"},
                {"LPH": "Philosophie"},
                {"LAL": "Arts et loisirs "},
                {"LD": "Droit"},
                {"LC": "conte"},
                {"LDO": "Documentaire"},
                {"LED": "Éducation"},
                {"LBD": "Bande dessinée"},
              ] :const [
                {"LLIT": "Littérature"},
                {"LROM": "Romans"},
                {"LPH": "Philosophie"},
                {"LAL": "Arts et loisirs "},
                {"LD": "Droit"},
                {"LC": "conte"},
                {"LDO": "Documentaire"},
                {"LED": "Éducation"},
                {"LBD": "Bande dessinée"},
                {"TOUTL": "autres"},
              ],

              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TOUTL": "Tout les livres"},
                    {"LLIT": "Littérature"},
                    {"LROM": "Romans"},
                    {"LPH": "Philosophie"},
                    {"LAL": "Arts et loisirs "},
                    {"LD": "Droit"},
                    {"LC": "conte"},
                    {"LDO": "Documentaire"},
                    {"LED": "Éducation"},
                    {"LBD": "Bande dessinée"},
                  ], selectedKey);
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
          if (selectedSubCategory == "tableaux") ...[
            const SizedBox(height: 12),
            CustomDropdownFormField<String, String>(
              image: true,
              pathImageHorsmenu: "assets/images/tableau.jpeg",
              label: "Sous catégorie de TABLEAUX",
              options: widget.isExplore ==true? const [
                {"TPEIN": "Touts les tableaux"},
                {"PH": "Peinture acrylique"},
                {"AQ": "Aquarelles"},
                {"CUB": "Cubisme"},
                {"ARTEXPR": "Expressionnisme"},
                {"REAL": "Réalisme"},
                {"ARTABS": "Art abstrait "},
                {"ARTPOP": "Pop art"},
                {"ARTPORT": "Portrait "},
                {"ARTIMPR": "impressionnisme "},
                {"ARTURB": "Art urban "},
              ]:const [
                {"PH": "Peinture acrylique"},
                {"AQ": "Aquarelles"},
                {"CUB": "Cubisme"},
                {"ARTEXPR": "Expressionnisme"},
                {"REAL": "Réalisme"},
                {"ARTABS": "Art abstrait "},
                {"ARTPOP": "Pop art"},
                {"ARTPORT": "Portrait "},
                {"ARTIMPR": "impressionnisme "},
                {"ARTURB": "Art urban "},
                {"TPEIN": "autres"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"TPEIN": "Toutes les peintures"},
                    {"PH": "Peinture acrylique"},
                    {"AQ": "Aquarelles"},
                    {"CUB": "Cubisme"},
                    {"ARTEXPR": "Expressionnisme"},
                    {"REAL": "Réalisme"},
                    {"ARTABS": "Art abstrait "},
                    {"ARTPOP": "Pop art"},
                    {"ARTPORT": "Portrait "},
                    {"ARTIMPR": "impressionnisme "},
                    {"ARTURB": "Art urban "},
                  ], selectedKey);
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
          if (selectedSubCategory == "SCUL") ...[
            const SizedBox(height: 12),
            CustomDropdownFormField<String, String>(
              image: true,
              pathImageHorsmenu: "assets/images/scul.jpeg",
              label: "Sous catégorie de SCULPTURES",
              options: widget.isExplore == true ? const [
                {"SCULT": "Toutes les sculptures"},
                {"SCULBR": "Bronzes"},
                {"SCULMAR": "Sculptures en marbre"},
                {"SCULPLA": "Sculptures en plâtre"},
                {"SCULBOI": "Sculptures en bois"},
                {"SCULTERRE": "Sculptures en terre cuite "},
              ]:const [
                {"SCULBR": "Bronzes"},
                {"SCULMAR": "Sculptures en marbre"},
                {"SCULPLA": "Sculptures en plâtre"},
                {"SCULBOI": "Sculptures en bois"},
                {"SCULTERRE": "Sculptures en terre cuite "},
                {"SCULT": "autres"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"SCULT": "Toutes les sculptures"},
                    {"SCULBR": "Bronzes"},
                    {"SCULMAR": "Sculptures en marbre"},
                    {"SCULPLA": "Sculptures en plâtre"},
                    {"SCULBOI": "Sculptures en bois"},
                    {"SCULTERRE": "Sculptures en terre cuite "},
                  ], selectedKey);
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
          if (selectedSubCategory == "ARTGRAPH") ...[
            const SizedBox(height: 12),
            CustomDropdownFormField<String, String>(
              image: true,
              pathImageHorsmenu: "assets/images/ag.jpeg",
              label: "Sous catégorie de art graphique",
              options: widget.isExplore ==true? const [
                {"PHOTOGRAPH": "Photographies"},
                {"AFFICH": "Affiches"},
                {"STREET": "Street art, graffiti"},
                {"AQUA": "Aquarelles"},
                {"OEUPAP": "Œuvres sur papier"},
              ]:const [
                {"PHOTOGRAPH": "Photographies"},
                {"AFFICH": "Affiches"},
                {"STREET": "Street art, graffiti"},
                {"AQUA": "Aquarelles"},
                {"OEUPAP": "Œuvres sur papier"},
                {"TOEU": "autres"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  for_field = getSelectedValue([
                    {"PHOTOGRAPH": "Photographies"},
                    {"AFFICH": "Affiches"},
                    {"STREET": "Street art, graffiti"},
                    {"AQUA": "Aquarelles"},
                    {"OEUPAP": "Œuvres sur papier"},
                    {"TOEU": "autres - art graphiques"},
                  ], selectedKey);
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
          SizedBox(
            height: 16,
          ),
          if (selectedCategory == null &&
              selectedSubCategory == null &&
              selectedSubSubCategory == null)
            CustomDropdownFormField<String, String>(
              image: true,
              pathImageHorsmenu: "assets/images/mv.jpeg",
              label: "Mode et vintage",
              isButton: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Gender(isExplore: widget.isExplore)));
              },
              options: const [
                {"": ""},
              ],

              // Utiliser la sous-catégorie sélectionnée comme valeur
            ),
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
              label: "Valider votre choix",
              onTap: () {
                handleSubmit(selectedSubCategory == "MONTRE");
              },
              isDisabled: selectedSubCategory == "MONTRE"
                  ? false
                  : selectedCategory == null ||
                      (selectedCategory == "MV" &&
                          (selectedSubCategory == null &&
                              selectedSubSubCategory == null)) ||
                      (selectedCategory == "OV" &&
                          selectedSubCategory == "tableaux" &&
                          (selectedSubCategory == null ||
                              selectedSubSubCategory == null)) ||
                      (selectedCategory == "L" &&
                          selectedSubCategory == null) ||
                      (selectedCategory == "OV" &&
                          selectedSubCategory == "ARTGRAPH" &&
                          (selectedSubCategory == null ||
                              selectedSubSubCategory == null)) ||
                      (selectedCategory == "OV" &&
                          selectedSubCategory == "SCUL" &&
                          (selectedSubCategory == null ||
                              selectedSubSubCategory == null))),
          SizedBox(
            width: 343,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
                children: <TextSpan>[
                  TextSpan(
                    style:
                        TextStyle(color: theme ? Colors.white : Colors.black),
                    text: "Ou vous pouvez ", // Partie du texte non stylisée
                  ),
                  TextSpan(
                    text:
                        "Réinitialiser", // Mot à colorier en rose et rendre interactif
                    style: TextStyle(
                      color: theme
                          ? Color.fromARGB(255, 249, 217, 144)
                          : Color(0xFFFB98B7), // Couleur rose
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
                    style:
                        TextStyle(color: theme ? Colors.white : Colors.black),
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
