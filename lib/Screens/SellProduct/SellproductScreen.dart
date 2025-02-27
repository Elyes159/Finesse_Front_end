// ignore_for_file: dead_code, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/SellProduct/Itemsubmitted.dart';
import 'package:finesse_frontend/Screens/SellProduct/categories.dart';
import 'package:finesse_frontend/Screens/SellProduct/itemModified.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/DescTextField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/foundation.dart';
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
  final product;
  const SellProductScreen(
      {super.key,
      this.category,
      this.keySubCategory,
      this.keyCategory,
      this.subcategory,
      this.subsubcategory,
      this.product});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  List<File?> _images = List.generate(5, (index) => null);
  late List<String> _networkImages;
  String? subCategoryOrSubsubcategory;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  final TextEditingController _possibleDeffectsController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _pointureController = TextEditingController();
  TextEditingController _tailleController = TextEditingController();
  TextEditingController _etatController = TextEditingController();
  TextEditingController _brandController = TextEditingController();

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
                  : widget.category == "L"
                      ? "Livre"
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
    _titleController = TextEditingController(
      text: widget.product != null ? widget.product["title"] : null,
    );
    _descriptionController = TextEditingController(
      text: widget.product != null ? widget.product["description"] : null,
    );
     _categoryController = TextEditingController(
      text: widget.product != null ? widget.product["frontend_category"] : null,
    );
    _priceController = TextEditingController(
      text: widget.product != null ? widget.product["price"] : null,
    );
    _initializeImages();
  }

  void _initializeImages() {
    if (widget.product != null && widget.product!["images"] != null) {
      List<String> imageUrls = List<String>.from(widget.product!["images"]);
      _networkImages = List.generate(5, (index) {
        return index < imageUrls.length ? imageUrls[index] : "";
      });
    } else {
      _networkImages = List.generate(5, (index) => "");
    }
    _images = List.generate(5, (index) => null);
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

  late String forBackend = "";
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
              Text(
                widget.product == null
                    ? 'Vendre un article'
                    : 'Modifier votre article',
                style: TextStyle(
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
                    'Ajoutez des informations sur les articles que vous vendez pour aider les clients à en savoir plus.',
                    style: TextStyle(
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
                        onTap: () => _pickImage(index),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _images[index] != null
                                ? Image.file(
                                    _images[index]!,
                                    fit: BoxFit.cover,
                                  )
                                : _networkImages[index].isNotEmpty
                                    ? Image.network(
                                        "${AppConfig.baseUrl}${_networkImages[index]}",
                                        fit: BoxFit.cover,
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/Icons/gallery.svg",
                                            ),
                                            const SizedBox(height: 12),
                                            const Text(
                                              'Ajouter une photo',
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
                        ),
                      );
                    }),
                  ),
                ),
              ),
              if(widget.product !=null)
              const Text("Si vous souhaitez changer les images, veuillez choisir de nouvelles images dès le début, car les anciennes seront supprimées.",style:TextStyle(fontFamily: "Raleway",color: Colors.grey)),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                  controller: _titleController,
                  label: 'Titre',
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _errorMessage = "osdhcoi";
                      return 'Le titre est obligatoire';
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
                      return 'La description est obligatoire';
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
                onTap: widget.product != null ? null : () async {
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

                    if (kDebugMode) {
                      print(forBackend);
                      print(subcategory);
                      print(subsubcategory);
                    }

                    setState(() {
                      // Mise à jour de la catégorie principale
                      _categoryController.text = category == "MV"
                          ? 'Mode et Vintage'
                          : category == "AC"
                              ? "Art et création"
                              : category == "D"
                                  ? "Decoration"
                                  : category == "L"
                                      ? "Livres"
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
                    label: 'Catégorie',
                    isPassword: false,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _errorMessage = "osdhcoi";
                        return 'La catégorie est obligatoire';
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
                label: "Prix",
                isPassword: false,
                keyboardType: TextInputType.numberWithOptions(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _errorMessage = "osdhcoi";
                    return 'le Prix et obligatoire';
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
                CustomDropdownFormField<String, String>(
                  options: const [
                    {'S': 'S'},
                    {'M': 'M'},
                    {'L': 'L'},
                    {'XL': 'XL'},
                    {'XXL': 'XXL'},
                    {'38': '38'},
                    {'40': '40'},
                    {'42': '42'},
                    {'44': '44'},
                  ],
                  label: "Taille",
                  selectedKey: null,
                  onChanged: (value) {
                    setState(() {
                      _tailleController.text = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Taille is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _tailleController.text = value ?? '';
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomDropdownFormField<String, String>(
                  options: const [
                    {'neuf_avec_etiquette': 'Neuf avec étiquette'},
                    {'neuf_sans_etiquette': 'Neuf sans étiquette'},
                    {'tres_bon_etat': 'Très bon état'},
                    {'bon_etat': 'Bon état'},
                    {'satisfaisant': 'Satisfaisant'},
                  ],
                  label: "État",
                  selectedKey: null,
                  onChanged: (value) {
                    setState(() {
                      _etatController.text = value ?? '';
                      print(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'État est obligatoire';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _etatController.text = value ?? '';
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomDropdownFormField<String, String>(
                  options: const [
                    {'nike': 'Nike'},
                    {'adidas': 'Adidas'},
                    {'armani': 'Armani'},
                    {'puma': 'Puma'},
                    {'reebok': 'Reebok'},
                    {'under_armour': 'Under Armour'},
                    {'new_balance': 'New Balance'},
                    {'converse': 'Converse'},
                    {'vans': 'Vans'},
                    {'fila': 'Fila'},
                    {'balenciaga': 'Balenciaga'},
                    {'tommy_hilfiger': 'Tommy Hilfiger'},
                    {'levi_s': 'Levi\'s'},
                    {'calvin_klein': 'Calvin Klein'},
                    {'lacoste': 'Lacoste'},
                    {'gucci': 'Gucci'},
                    {'chanel': 'Chanel'},
                    {'louis_vuitton': 'Louis Vuitton'},
                    {'prada': 'Prada'},
                    {'burberry': 'Burberry'},
                  ],
                  label: "Marque", // Changer "État" en "Marque"
                  selectedKey: null,
                  onChanged: (value) {
                    setState(() {
                      _brandController.text = value ?? '';
                      print(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La marque est requise';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _brandController.text = value ?? '';
                  },
                )
              ],
              const SizedBox(
                height: 24,
              ),
              if(_errorMessage!=null)
              Text("$_errorMessage"),
              CustomButton(
                buttonColor:
                    _Loading ? const Color(0xffE5E7EB) : Color(0xffFB98B7),
                textColor: _Loading ? Color(0xff111928) : Colors.white,
                onTap: _Loading
                    ? () {}
                    : () async {
                        setState(() {
                          _Loading = true;
                        });
                        _errorMessage = null;
                        if (widget.product == null &&
                            _images != null &&
                            _priceController.text.isNotEmpty &&
                            int.parse(_priceController.text) >= 10 &&
                            _titleController.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty &&
                            _categoryController.text.isNotEmpty) {
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
                            _tailleController.text,
                            _pointureController.text,
                            _etatController.text,
                            _brandController.text,
                            _images,
                          );
                          if (result) {
                            setState(() {
                              _Loading = false;
                            });
                            Navigator.pushAndRemoveUntil(
                              // ignore: use_build_context_synchronously
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
                            setState(() {
                              _Loading = false;
                            });
                          }
                        } else if (widget.product != null &&
                            _priceController.text.isNotEmpty &&
                            double.parse(_priceController.text) >= 10 &&
                            _titleController.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty &&
                            _categoryController.text.isNotEmpty) {
                          double? price =
                              double.tryParse(_priceController.text);
                          int? quantity =
                              int.tryParse(_quantityController.text);

                          print("heeeeeeeeeeeeey $subCategoryOrSubsubcategory");

                          // Appel de la méthode sellProduct et capture du résultat
                          final bool result = await Provider.of<Products>(
                                  context,
                                  listen: false)
                              .updateProduct(
                              widget.product["id"],
                            _titleController.text,
                            _descriptionController.text,
                            widget.product["backend_category"], // Sous-catégorie obtenue depuis Navigator.push
                            price!,
                            _possibleDeffectsController.text,
                            _tailleController.text,
                            _pointureController.text,
                            _etatController.text,
                            _brandController.text,
                            _images,
                          );
                          if (result) {
                            setState(() {
                              _Loading = false;
                            });
                            Navigator.pushAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemModified(),
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
                            setState(() {
                              _Loading = false;
                            });
                          }
                        } else {
                          _errorMessage =
                              "Le formulaire n'est pas valide ! Veuillez remplir tous les champs obligatoires. ou augmentez le prix";
                          setState(() {
                            _Loading = false;
                          });
                        }
                        setState(() {
                          _Loading = false;
                        });
                      },
                label: widget.product == null
                    ? "Publier l'article"
                    : "Modifier l'article",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
