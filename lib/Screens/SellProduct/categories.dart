import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/customchekcoptionfield/customchekcoptionfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({super.key});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  String? selectedCategory; // Catégorie sélectionnée
  String? selectedSubCategory;
  String?
      selectedSubSubCategory; // Sous-catégorie sélectionnée dans "Vêtements"
  Map<String, bool> selectedCheckboxes = {
    "Men": false,
    "Women": false,
    "Boys": false,
    "Girls": false,
  };
  String? errorMessage;

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      selectedSubCategory = null;
      errorMessage = null;
    });
  }

  void toggleCheckbox(String key, bool value) {
    setState(() {
      selectedCheckboxes[key] = value;
      errorMessage = null;
    });
  }

  bool validateCheckboxSelection() {
    int checkedCount =
        selectedCheckboxes.values.where((isChecked) => isChecked).length;
    return checkedCount == 1;
  }

  void handleSubmit() {
    if (selectedCategory == null) {
      setState(() {
        errorMessage = "Please select a category.";
      });
      return;
    }

    if (selectedCategory == "Mode and vintage") {
      if (!validateCheckboxSelection()) {
        setState(() {
          errorMessage =
              "Please select exactly one option from Men, Women, Boys, or Girls.";
        });
        return;
      }
    }

    setState(() {
      errorMessage = null;
    });

    print("Category chosen: $selectedCategory");
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
              'Choose a category',
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
              'Select a category for your item from the list below',
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
          const SizedBox(height: 24),
          CustomDropdownFormField<String, String>(
            label: "Art and creation",
            options: const [
              {"mode": "Mode"},
              {"vintage": "Vintage"},
            ],
            onChanged: (selectedKey) {
              selectCategory("Art and creation");
            },
            selectedKey: selectedCategory == "Art and creation" ? "mode" : null,
          ),
          const SizedBox(height: 12),
          CustomDropdownFormField<String, String>(
            label: "Decoration",
            options: const [
              {"mode": "Mode"},
              {"vintage": "Vintage"},
            ],
            onChanged: (selectedKey) {
              selectCategory("Decoration");
            },
            selectedKey: selectedCategory == "Decoration" ? "mode" : null,
          ),
          const SizedBox(height: 12),
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
            ],
            onChanged: (selectedKey) {
              setState(() {
                selectedCategory =
                    "MV"; // Mettre la catégorie principale sur "Mode et Vintage"
                selectedSubCategory =
                    selectedKey; // Mettre la sous-catégorie avec la clé sélectionnée
                errorMessage = null; // Réinitialiser le message d'erreur
              });
            },
            selectedKey:
                selectedSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
          ),
          if (selectedSubCategory == "J") ...[
            const SizedBox(height: 12),
            CustomDropdownFormField<String, String>(
              label: "Sub-category of Jouets",
              options: const [
                {"robe": "Robe"},
                {"caftan": "Caftan"},
                {"t-shirt": "T-Shirt"},
                {"pull chemise": "Pull Chemise"},
                {"gilet": "Gilet"},
                {"veste": "Veste"},
                {"manteau": "Manteau"},
                {"trench": "Trench"},
                {"pantalon": "Pantalon"},
                {"pantacourt": "Pantacourt"},
                {"short": "Short"},
                {"salopette": "Salopette"},
                {"jupe": "Jupe"},
                {"maillot": "Maillot"},
                {"lingerie": "Lingerie"},
                {"pyjamas": "Pyjamas"},
                {"kimono": "Kimono"},
                {"combinaison": "Combinaison"},
                {"sari": "Sari"},
                {"ensemble": "Ensemble"},
              ],
              onChanged: (selectedKey) {
                setState(() {
                  selectedSubSubCategory =
                      selectedKey; // Mise à jour de la sous-catégorie
                });
              },
              selectedKey:
                  selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
            ),
          ],
          if (selectedSubCategory == "P") ...[
            const SizedBox(height: 12),
            CustomDropdownFormField<String, String>(
              label: "Sub-category of Produit de beauté",
              options: const [
                {"robe": "Robe"},
                {"caftan": "Caftan"},
                {"t-shirt": "T-Shirt"},
                {"pull chemise": "Pull Chemise"},
                {"gilet": "Gilet"},
                {"veste": "Veste"},
                {"manteau": "Manteau"},
                {"trench": "Trench"},
                {"pantalon": "Pantalon"},
                {"pantacourt": "Pantacourt"},
                {"short": "Short"},
                {"salopette": "Salopette"},
                {"jupe": "Jupe"},
                {"maillot": "Maillot"},
                {"lingerie": "Lingerie"},
                {"pyjamas": "Pyjamas"},
                {"kimono": "Kimono"},
                {"combinaison": "Combinaison"},
                {"sari": "Sari"},
                {"ensemble": "Ensemble"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
                {"robe": "Robe"},
                {"caftan": "Caftan"},
                {"t-shirt": "T-Shirt"},
                {"pull chemise": "Pull Chemise"},
                {"gilet": "Gilet"},
                {"veste": "Veste"},
                {"manteau": "Manteau"},
                {"trench": "Trench"},
                {"pantalon": "Pantalon"},
                {"pantacourt": "Pantacourt"},
                {"short": "Short"},
                {"salopette": "Salopette"},
                {"jupe": "Jupe"},
                {"maillot": "Maillot"},
                {"lingerie": "Lingerie"},
                {"pyjamas": "Pyjamas"},
                {"kimono": "Kimono"},
                {"combinaison": "Combinaison"},
                {"sari": "Sari"},
                {"ensemble": "Ensemble"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
                {"robe": "Robe"},
                {"caftan": "Caftan"},
                {"t-shirt": "T-Shirt"},
                {"pull chemise": "Pull Chemise"},
                {"gilet": "Gilet"},
                {"veste": "Veste"},
                {"manteau": "Manteau"},
                {"trench": "Trench"},
                {"pantalon": "Pantalon"},
                {"pantacourt": "Pantacourt"},
                {"short": "Short"},
                {"salopette": "Salopette"},
                {"jupe": "Jupe"},
                {"maillot": "Maillot"},
                {"lingerie": "Lingerie"},
                {"pyjamas": "Pyjamas"},
                {"kimono": "Kimono"},
                {"combinaison": "Combinaison"},
                {"sari": "Sari"},
                {"ensemble": "Ensemble"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
                {"robe": "Robe"},
                {"caftan": "Caftan"},
                {"t-shirt": "T-Shirt"},
                {"pull chemise": "Pull Chemise"},
                {"gilet": "Gilet"},
                {"veste": "Veste"},
                {"manteau": "Manteau"},
                {"trench": "Trench"},
                {"pantalon": "Pantalon"},
                {"pantacourt": "Pantacourt"},
                {"short": "Short"},
                {"salopette": "Salopette"},
                {"jupe": "Jupe"},
                {"maillot": "Maillot"},
                {"lingerie": "Lingerie"},
                {"pyjamas": "Pyjamas"},
                {"kimono": "Kimono"},
                {"combinaison": "Combinaison"},
                {"sari": "Sari"},
                {"ensemble": "Ensemble"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
                {"bottes": "Bottes"},
                {"bottines": "Bottines"},
                {"escarpins": "Escarpins"},
                {"compenses": "Compensés"},
                {"sandales": "Sandales"},
                {"baskets": "Baskets"},
                {"espadrilles": "Espadrilles"},
                {"slip-on": "Slip-on"},
                {"ballerines": "Ballerines"},
                {"mules": "Mules"},
                {"derbies": "Derbies"},
                {"bebe": "Bébé"},
                {"chaussons": "Chaussons"},
                {"mocassins": "Mocassins"},
              ],
              onChanged: (selectedKey) {
                setState(() {
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
                {"CA": "Caftan"},
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
                  selectedSubSubCategory =
                      selectedKey; // Mise à jour de la sous-catégorie
                });
              },
              selectedKey:
                  selectedSubSubCategory, // Utiliser la sous-catégorie sélectionnée comme valeur
            ),
          ],
          const SizedBox(height: 24),
          if (selectedCategory == "Mode and vintage") ...[
            CustomCheckboxFormField(
              label: "Men",
              initialValue: selectedCheckboxes["Men"]!,
              onChanged: (newValue) => toggleCheckbox("Men", newValue),
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Women",
              initialValue: selectedCheckboxes["Women"]!,
              onChanged: (newValue) => toggleCheckbox("Women", newValue),
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Boys",
              initialValue: selectedCheckboxes["Boys"]!,
              onChanged: (newValue) => toggleCheckbox("Boys", newValue),
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Girls",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) => toggleCheckbox("Girls", newValue),
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
            label: "Choose Category",
            onTap: handleSubmit,
          ),
        ],
      ),
    );
  }
}
