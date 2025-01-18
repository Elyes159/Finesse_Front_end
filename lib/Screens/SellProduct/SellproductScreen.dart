// ignore_for_file: dead_code

import 'dart:io';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/SellProduct/Itemsubmitted.dart';
import 'package:finesse_frontend/Screens/SellProduct/categories.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/DescTextField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SellProductScreen extends StatefulWidget {
  final String? category;
  final String? subcategory;
  final String? subsubcategory;

  final String? keySubCategory;
  final String? keyCategory;
  const SellProductScreen({
    super.key,
    this.category,
    this.keySubCategory,
    this.keyCategory,
    this.subcategory,
    this.subsubcategory,
  });

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

  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

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

    _categoryController = TextEditingController(
      text: widget.category == "MV"
          ? 'Mode and Vintage'
          : widget.category == "AC"
              ? "Art and creation"
              : widget.category == "D"
                  ? "Decoration"
                  : "",
    );
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

    // Vérifier à la fois subcategory et subsubcategory
    final String? subCategory = widget.subcategory?.isNotEmpty == true
        ? widget.subcategory
        : widget.subsubcategory?.isNotEmpty == true
            ? widget.subsubcategory
            : null;

    // Si une sous-catégorie est définie et qu'elle est dans le mappage, l'ajouter
    if (subCategory != null && subCategoryMapping.containsKey(subCategory)) {
      final subCategoryText = subCategoryMapping[subCategory]!;
      _categoryController.text +=
          " - $subCategoryText"; // Ajouter la sous-catégorie au texte
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Si le formulaire est valide
      print("Form submitted successfully!");
    } else {
      // Si le formulaire n'est pas valide
      print("Form is not valid! Please fill all required fields.");
    }
  }

  late String forBackend;
  late String subcategory = "";
  late String category = "";
  bool _Loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Ajout du FormKey
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
                  print(widget.category);
                  print(category);
                  print(subcategory);
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
                height: 160,
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
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _errorMessage = "osdhcoi";
                      return 'Title is required';
                    } else {
                      setState(() {
                        _errorMessage = null;
                      });
                      return null;
                    }
                  }),
              const SizedBox(
                height: 16,
              ),
              DescTextField(
                  controller: _descriptionController,
                  label: "Description",
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _errorMessage = "osdhcoi";
                      return 'Description is required';
                    } else {
                      setState(() {
                        _errorMessage = null;
                      });
                      return null;
                    }
                  }),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () async {
                  // Appel à ChooseCategory et récupération des données
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseCategory(),
                    ),
                  );

                  // Mise à jour des champs avec les données retournées
                  if (result != null) {
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
                    category = result['category'] ?? "";
                    forBackend = result['forBackend'] ?? "";
                    subcategory = result['subcategory'] ?? "";
                    final String subsubcategory =
                        result['subsubcategory'] ?? "";
                    print("trah chouf houni");
                    print(forBackend);
                    print(category);
                    print(subcategory);
                    print(subsubcategory);
                    setState(() {
                      // Mise à jour de la catégorie principale
                      _categoryController.text = category == "MV"
                          ? 'Mode and Vintage'
                          : category == "AC"
                              ? "Art and creation"
                              : category == "D"
                                  ? "Decoration"
                                  : "";

                      // Définir la sous-catégorie ou sous-sous-catégorie
                      final String? mappedSubCategory = subcategory != null
                          ? subCategoryMapping[subcategory]
                          : subCategoryMapping[subsubcategory];

                      if (mappedSubCategory != null) {
                        _categoryController.text += " - $mappedSubCategory";
                      }

                      subCategoryOrSubsubcategory =
                          subcategory != null ? subcategory : subsubcategory;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    controller: _categoryController,
                    label: "Category",
                    isPassword: false,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _errorMessage = "osdhcoi";
                        return 'Category is required';
                      } else {
                        setState(() {
                          _errorMessage = null;
                        });
                        return null;
                      }
                      return null;
                    },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _errorMessage = "osdhcoi";
                    return 'Price is required';
                  } else {
                    setState(() {
                      _errorMessage = null;
                    });
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              if (subcategory == "C") ...[
                CustomTextFormField(
                  controller: _pointureController,
                  label: "Pointure",
                  isPassword: false,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _errorMessage = "osdhcoi";
                      return 'Pointure is required';
                    } else {
                      setState(() {
                        _errorMessage = null;
                      });
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
              if (subcategory == "V") ...[
                CustomTextFormField(
                  controller: _tailleController,
                  label: "Taille",
                  isPassword: false,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _errorMessage = "osdhcoi";
                      return 'Taille is required';
                    } else {
                      setState(() {
                        _errorMessage = null;
                      });
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
              CustomTextFormField(
                controller: _possibleDeffectsController,
                label: "Possible deffects",
                isPassword: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _errorMessage = "osdhcoi";
                    return 'Possible defects are required';
                  } else {
                    setState(() {
                      _errorMessage = null;
                    });
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                controller: _quantityController,
                label: "Quantity",
                isPassword: false,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _errorMessage = "osdhcoi";
                    return 'Quantity is required';
                  } else {
                    setState(() {
                      _errorMessage = null;
                    });
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
              if (_errorMessage != null)
                Text(
                  "$_errorMessage",
                  style: const TextStyle(
                      color: Colors.red, fontFamily: "Raleway", fontSize: 14),
                ),
              CustomButton(
                buttonColor: _Loading ? const Color(0xffE5E7EB) : Color(0xffFB98B7),
                textColor: _Loading ? Color(0xff111928) : Colors.white,
                onTap: _Loading
                    ? () {}
                    : () async {
                        setState(() {
                          _Loading = true;
                        });
                        _errorMessage = null;
                        if (_formKey.currentState?.validate() ?? false) {
                          double? price =
                              double.tryParse(_priceController.text);
                          int? quantity =
                              int.tryParse(_quantityController.text);

                          print("heeeeeeeeeeeeey $subCategoryOrSubsubcategory");

                          // Appel de la méthode sellProduct et capture du résultat
                          final bool result = await Provider.of<Products>(
                                  context,
                                  listen: false)
                              .sellProduct(
                            _titleController.text,
                            _descriptionController.text,
                            forBackend.isNotEmpty
                                ? forBackend
                                : subcategory, // Sous-catégorie obtenue depuis Navigator.push
                            price!,
                            _possibleDeffectsController.text,
                            quantity,
                            _tailleController.text,
                            _pointureController.text,
                            _images,
                          );
                          if (result) {
                            setState(() {
                              _Loading = false;
                            });
                            print("Form submitted successfully!");
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemSubmitted(),
                              ),
                              (route) => false,
                            );
                          } else {
                            // Si une erreur survient, récupérer et afficher le message d'erreur
                            setState(() {
                              _errorMessage =
                                  Provider.of<Products>(context, listen: false)
                                      .errorMessage;
                            });
                            print("Error: $_errorMessage");
                            setState(() {
                              _Loading = false;
                            });
                          }
                        } else {
                          _errorMessage =
                              "Form is not valid! Please fill all required fields.";
                          print(
                              "Form is not valid! Please fill all required fields.");
                        }
                        setState(() {
                          _Loading = false;
                        });
                      },
                label: "Publish item",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
