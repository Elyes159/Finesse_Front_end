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
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedSubSubCategory;
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
    selectedSubCategory = null;  // Reset selected sub-category when a new category is selected
    errorMessage = null;
    
    // Si "Mode et Vintage" est sélectionné, choisir une sous-catégorie par défaut
    if (category == "MV" && selectedSubCategory == null) {
      selectedSubCategory = "V";  // Exemple de sous-catégorie par défaut ("Vêtements")
    }
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
    return checkedCount == 1; // Exactement une case cochée
  }

  void handleSubmit() {
    if (selectedCategory == null) {
      setState(() {
        errorMessage = "Please select a category.";
      });
      return;
    }

    if (selectedCategory == "MV") {
      if (selectedSubCategory == null) {
        setState(() {
          errorMessage = "Please select a sub-category.";
        });
        return;
      }

      if (!validateCheckboxSelection()) {
        setState(() {
          errorMessage =
              "Please select exactly one gender (Men, Women, Boys, or Girls).";
        });
        return;
      }
    }

    // Si toutes les validations passent
    setState(() {
      errorMessage = null;
    });

    // Logic for handling category selection
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
                {"CH": "Chaussons"},
                {"MO": "Mocassins"},
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
          if (selectedCategory == "MV" &&
              {"S", "A", "C", "V"}.contains(selectedSubCategory)) ...[
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
          if (selectedCategory == "MV" &&
              {"B"}.contains(selectedSubCategory)) ...[
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Women",
              initialValue: selectedCheckboxes["Women"]!,
              onChanged: (newValue) => toggleCheckbox("Women", newValue),
            ),
            const SizedBox(height: 12),
            CustomCheckboxFormField(
              label: "Girls",
              initialValue: selectedCheckboxes["Girls"]!,
              onChanged: (newValue) => toggleCheckbox("Girls", newValue),
            ),
          ],
          if (selectedCategory == "MV" &&
              {"J"}.contains(selectedSubCategory)) ...[
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
          if (selectedCategory == "MV" &&
              {"P"}.contains(selectedSubCategory)) ...[
            const SizedBox(height: 12),
            const CustomCheckboxFormField(
              label: "Women",
              initialValue: true, // Par défaut cochée
              onChanged: null, // Désactiver l'interaction utilisateur
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
            isDisabled: selectedCategory == null ||
                (selectedCategory == "MV" &&
                    (selectedSubCategory == null ||
                        !validateCheckboxSelection())),
          ),
        ],
      ),
    );
  }
}
