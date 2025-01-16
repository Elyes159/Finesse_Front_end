import 'dart:io';

import 'package:finesse_frontend/Screens/SellProduct/categories.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/DescTextField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class SellProductScreen extends StatefulWidget {
  final String? category;
  final String? subcategory;
  final String? subsubcategory;

  final String? keySubCategory;
  final String? keyCategory;
  const SellProductScreen(
      {super.key,
      this.category,
      this.keySubCategory,
      this.keyCategory,
      this.subcategory,
      this.subsubcategory});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  final List<File?> _images = List.generate(5, (index) => null);
  String? subCategoryOrSubsubcategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _possibleDeffectsController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _pointureController = TextEditingController();
  TextEditingController _tailleController = TextEditingController();

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _images[index] =
            File(pickedFile.path); // Met à jour l'image sélectionnée
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialisez le TextEditingController avec la valeur de category si elle est non nulle
    _categoryController = TextEditingController(
      text: widget.category == "MV"
          ? 'Mode and Vintage'
          : widget.category == "AC"
              ? "Art and creation"
              : widget.category == "D"
                  ? "Decoration"
                  : "",
    );

    // Map des correspondances pour les sous-catégories
    final Map<String, String> subCategoryMapping = {
      "V": "Vêtements",
      "C": "Chaussures",
      "B": "Bijoux",
      "A": "Accessoires",
      "S": "Sacs",
      "P": "Produits de beauté",
      "J": "Jouets",
      "PEIN": "Peinture"
    };

    final subCategoryOrSubSubcategory = (widget.subcategory != null &&
            widget.subcategory!.isNotEmpty)
        ? widget.subcategory
        : (widget.subsubcategory != null && widget.subsubcategory!.isNotEmpty)
            ? widget.subsubcategory
            : null;

    // Ajoutez la sous-catégorie uniquement si elle existe dans le mapping
    if (subCategoryOrSubSubcategory != null &&
        subCategoryMapping.containsKey(subCategoryOrSubSubcategory)) {
      final subCategoryText = subCategoryMapping[subCategoryOrSubSubcategory]!;
      _categoryController.text += " - $subCategoryText";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Sell item',
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
            InkWell(
              onTap: () {
                print(widget.keyCategory);
                print(widget.subcategory);
                print(widget.category);
              },
              child: const SizedBox(
                width: 343,
                child: Text(
                  'Add information about items you’re selling to help customers know more about it',
                  style: TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 14,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 160, // Hauteur définie pour contenir les éléments
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () =>
                          _pickImage(index), // Ouvre le sélecteur d'images
                      child: Container(
                        width: 150,
                        height: 150,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE5E7EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _images[index] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _images[index]!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/Icons/gallery.svg",
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Add photo',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextFormField(
                controller: _titleController,
                label: "Title",
                isPassword: false),
            const SizedBox(
              height: 16,
            ),
            DescTextField(
                controller: _descriptionController,
                label: "Description",
                isPassword: false),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChooseCategory()),
                );
              },
              child: AbsorbPointer(
                // Empêche l'interaction avec le TextField
                child: CustomTextFormField(
                  controller: _categoryController,
                  label: "Category",
                  isPassword: false,
                  keyboardType: TextInputType.numberWithOptions(),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextFormField(
              controller: _priceController,
              label: "Price",
              isPassword: false,
              keyboardType: TextInputType.numberWithOptions(),
            ),
            const SizedBox(
              height: 16,
            ),
            if (widget.subcategory == "C") ...[
              CustomTextFormField(
                controller: _pointureController,
                label: "Pointure",
                isPassword: false,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
            ],
            if (widget.subcategory == "V") ...[
              CustomTextFormField(
                controller: _tailleController,
                label: "Taille",
                isPassword: false,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
            ],
            CustomTextFormField(
              controller: _possibleDeffectsController,
              label: "Possible deffects",
              isPassword: false,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextFormField(
              controller: _quantityController,
              label: "Quantity",
              isPassword: false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 24,
            ),
            CustomButton(label: "Publish item", onTap: (){})
          ],
        ),
      ),
    );
  }
}
