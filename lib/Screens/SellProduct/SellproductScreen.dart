// ignore_for_file: dead_code, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/sellprovider.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/SellProduct/Itemsubmitted.dart';
import 'package:finesse_frontend/Screens/SellProduct/categories.dart';
import 'package:finesse_frontend/Screens/SellProduct/itemModified.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/DescTextField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:color_parser/color_parser.dart';

class SellProductScreen extends StatefulWidget {
  final String? category;
  final String? subcategory;
  final String? subsubcategory;
  String? categoryFromMv;
  final String? category_for_field;
  final String? keySubCategory;
  final String? keyCategory;
  final product;
  SellProductScreen(
      {super.key,
      this.category,
      this.category_for_field,
      this.keySubCategory,
      this.keyCategory,
      this.subcategory,
      this.subsubcategory,
      this.product,
      this.categoryFromMv});

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
  final TextEditingController _pointureController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  final TextEditingController _etatController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _dimensionController = TextEditingController();
  final TextEditingController _longeurController = TextEditingController();
  final TextEditingController _largeurController = TextEditingController();
  final TextEditingController _hauteurController = TextEditingController();
  final PageStorageBucket _bucket = PageStorageBucket();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _colorController = TextEditingController();
  Color _selectedColor = Colors.blue; // Couleur par défaut
  Map<Color, String> colorNames = {
    Colors.red: "Rouge",
    Colors.green: "Vert",
    Colors.blue: "Bleu",
    Colors.yellow: "Jaune",
    Colors.orange: "Orange",
    Colors.purple: "Violet",
    Colors.pink: "Rose",
    Colors.brown: "Marron",
    Colors.grey: "Gris",
    Colors.black: "Noir",
    Colors.white: "Blanc",
  };
  String getColorName(Color color) {
    return colorNames.entries
        .firstWhere(
          (entry) => entry.key.value == color.value,
          orElse: () => MapEntry(color,
              '#${color.value.toRadixString(16).substring(2).toUpperCase()}'),
        )
        .value;
  }

  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _selectedColor;

        return AlertDialog(
          title: const Text(
            "Choisissez une couleur",
            style: TextStyle(fontFamily: "Raleway"),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                tempColor = color;
              },
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Annuler",
                style: TextStyle(
                  fontFamily: "Raleway",
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedColor = tempColor;

                  String colorName = getColorName(_selectedColor);

                  _colorController.text =
                      colorName; // Mettre le nom dans le TextField
                });
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(
                  fontFamily: "Raleway",
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String? _errorMessage;

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      Provider.of<SellProductProvider>(context, listen: false)
          .setImage(index, image);
    }
  }

  @override
  void initState() {
    super.initState();
    final sellProductProvider =
        Provider.of<SellProductProvider>(context, listen: false);

    _categoryController = TextEditingController(
      text: widget.category == "MV"
          ? 'Mode and Vintage'
          : widget.category == "OV"
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
    // Restaurer la catégorie depuis PageStorage
    subCategoryOrSubsubcategory = widget.subcategory;

    _titleController = TextEditingController(
      text: widget.product?["title"] ?? sellProductProvider.title ?? "",
    );

    _descriptionController = TextEditingController(
      text: (widget.product?["description"] ??
          sellProductProvider.description ??
          ""),
    );

    _priceController = TextEditingController(
      text: widget.product?["price"] ??
          (sellProductProvider.price?.toString() ?? ""),
    );

    _categoryController = TextEditingController(
      text: (widget.product != null
          ? widget.product["frontend_category"]
          : widget.categoryFromMv != null
              ? "Mode et vintage"
              : ""),
    );

    _initializeImages();
  }

  void _initializeImages() {
    final sellProductProvider =
        Provider.of<SellProductProvider>(context, listen: false);

    // Récupérer les images depuis le provider si elles existent
    _images = sellProductProvider.images.isNotEmpty
        ? List.from(sellProductProvider.images)
        : List.generate(5, (index) => null);

    // Récupérer les images réseau depuis widget.product si elles existent
    _networkImages = widget.product != null && widget.product!["images"] != null
        ? List<String>.from(widget.product!["images"])
        : List.generate(5, (index) => "");
  }

  Future<bool> _onWillPop() async {
    // Affiche un dialog de confirmation
    bool? confirmExit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir quitter cette page ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Annule la navigation
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Autorise la navigation
              },
              child: Text('Quitter'),
            ),
          ],
        );
      },
    );

    // Si l'utilisateur confirme, on permet de quitter la page
    return confirmExit ?? false;
  }

  late String forBackend = "";
  late String subcategory = "";
  late String category = "";
  bool _Loading = false;
  List<Color> colors = [
    Colors.black, // Noir
    Colors.white, // Blanc
    Colors.grey, // Gris
    Color(0xFFD4AF37), // Doré
    Color(0xFFC0C0C0), // Argent
    Colors.red, // Rouge
    Colors.blue, // Bleu
    Colors.yellow, // Jaune
    Colors.green, // Vert
    Color(0xFF40E0D0), // Turquoise
    Color(0xFFAFEEEE), // Vert d'eau
    Color(0xFFF5F5DC), // Beige
    Color(0xFF6A4E23), // Marron
    Color(0xFFC19A6B), // Camel
    Colors.orange, // Orange
    Color(0xFFFF7F50), // Corail
    Color(0xFFFF66B2), // Rose
    Color(0xFF8A2BE2), // Violet
    Color(0xFF9B111E), // Bordeaux
    Color(0xFFF3C8A0), // Rose poudré
    Color(0xFFF2D1C9), // Nude
    Color(0xFF000080), // Bleu marine
    Color(0xFF4B5320), // Kaki
    Color(0xFF006400), // Vert foncé
  ];

  @override
  Widget build(BuildContext context) {
    bool showIntro = Provider.of<AuthService>(context, listen: false).showIntro;
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey, // Ajout du FormKey
            child: ListView(children: [
              if (showIntro) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gagnez plus sur chaque vente",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize:
                                    18, // Agrandissement de la taille du texte
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),

                            /// Étape 1 : Création de l'annonce
                            Row(
                              children: [
                                Icon(Icons.arrow_forward, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Créez votre annonce",
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize:
                                        14, // Agrandissement de la taille du texte
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Ajoutez des photos et des détails de votre article.",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Raleway",
                              ),
                            ),
                            SizedBox(height: 8),

                            /// Étape 2 : Vente
                            Row(
                              children: [
                                Icon(Icons.arrow_forward, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Vendez",
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize:
                                        16, // Agrandissement de la taille du texte
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Négociez directement en commentaires avec les acheteurs pour vendre plus rapidement. "
                              "Une fois votre article vendu, vous recevrez un code de livraison spécifique.",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Raleway",
                              ),
                            ),
                            SizedBox(height: 8),

                            /// Étape 3 : Livraison
                            Row(
                              children: [
                                Icon(Icons.arrow_forward, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Livraison",
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize:
                                        16, // Agrandissement de la taille du texte
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Le code devra être joint à votre commande, et un livreur viendra récupérer l’article sous 24 heures.",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Raleway",
                              ),
                            ),
                            SizedBox(height: 8),

                            /// Étape 4 : Paiement
                            Row(
                              children: [
                                Icon(Icons.arrow_forward, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Paiement",
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize:
                                        16, // Agrandissement de la taille du texte
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Le paiement de la somme vous sera effectué 48 heures après la livraison.",
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'Raleway'),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme
                                ? const Color.fromARGB(255, 249, 217, 144)
                                : const Color(0xFF5C7CA4),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Transparence avec l’acheteur",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme
                                    ? Color.fromARGB(255, 249, 217, 144)
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Mentionner tout défaut garantit que l’acheteur est bien informé avant de prendre sa décision, ce qui évite les conflits et les retours non souhaités.\n"
                              "1. Description détaillée du défaut : Indiquez clairement tout dommage, rayure, déformation, ou tout autre problème visible sur l’article.\n"
                              "2. Photos des défauts : Si possible, prenez des photos qui montrent les défauts de manière précise.",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme
                                    ? Color.fromARGB(255, 249, 217, 144)
                                    : Colors.black,
                                height: 1.5, // Espacement entre les lignes
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /// Bouton pour masquer l'intro et accéder à la vente
                      CustomButton(
                        onTap: () {
                          setState(() {
                            Provider.of<AuthService>(context, listen: false)
                                .setShowIntro(false);
                          });
                        },
                        label: ("J'ai compris"),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                InkWell(
                  onTap: () {
                    print(widget.category);
                  },
                  child: GestureDetector(
                    onTap: () {
                      print(subcategory);
                      print(category);
                      print(widget.category);
                      print(widget.categoryFromMv);
                    },
                    child: Text(
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
                  ),
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
                        return Consumer<SellProductProvider>(
                          builder: (context, sellProductProvider, child) {
                            return GestureDetector(
                              onTap: () => _pickImage(index),
                              child: Container(
                                width: 150,
                                height: 150,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE5E7EB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: sellProductProvider.images.length >
                                              index &&
                                          sellProductProvider.images[index] !=
                                              null
                                      ? Image.file(
                                          sellProductProvider.images[index]!,
                                          fit: BoxFit.cover,
                                        )
                                      : (_networkImages.length > index &&
                                              _networkImages[index].isNotEmpty)
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
                                                      "assets/Icons/gallery.svg"),
                                                  const SizedBox(height: 12),
                                                  const Text(
                                                    'Ajouter une photo',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Raleway',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ),
                if (widget.product != null)
                  const Text(
                      "Si vous souhaitez changer les images, veuillez choisir de nouvelles images dès le début, car les anciennes seront supprimées.",
                      style:
                          TextStyle(fontFamily: "Raleway", color: Colors.grey)),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                    controller: _titleController,
                    onChanged: (value) {
                      Provider.of<SellProductProvider>(context, listen: false)
                          .setTitle(value);
                    },
                    label: 'Titre',
                    isPassword: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _errorMessage = "titre obligatoire";
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
                    onChanged: (value) {
                      Provider.of<SellProductProvider>(context, listen: false)
                          .setDescription(value);
                    },
                    isPassword: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _errorMessage = "description obligatoire";
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
                  onTap: widget.product != null
                      ? null
                      : () async {
                          widget.categoryFromMv = null;
                          // Appel à ChooseCategory et récupération des données
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseCategory(
                                isExplore: false,
                              ),
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
                              print("hahom houni chouf");
                              print(forBackend);
                              print(subcategory);
                              print(subsubcategory);
                            }

                            setState(() {
                              // Mise à jour de la catégorie principale
                              _categoryController.text = category == "MV"
                                  ? 'Mode et Vintage'
                                  : category == "OV"
                                      ? "Oeuvre d'art"
                                      : category == "D"
                                          ? "Decoration"
                                          : category == "L"
                                              ? "Livres"
                                              : category == "CRA"
                                                  ? "Créations artisanales"
                                                  : widget.categoryFromMv !=
                                                          null
                                                      ? "Mode et Vintage"
                                                      : "";

                              // Définir la sous-catégorie ou sous-sous-catégorie
                              final String? mappedSubCategory =
                                  subcategory != null
                                      ? subCategoryMapping[subcategory]
                                      : subCategoryMapping[subsubcategory];

                              if (mappedSubCategory != null) {
                                _categoryController.text +=
                                    " - $mappedSubCategory";
                              }

                              subCategoryOrSubsubcategory = subcategory;
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
                          _errorMessage = "categorie";
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
                  onChanged: (value) {
                    Provider.of<SellProductProvider>(context, listen: false)
                        .setPrice(value);
                  },
                  label: "Prix",
                  isPassword: false,
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _errorMessage = "le prix minimum est de 10 dinars";
                      return 'le prix minimum est de 10 dinars';
                    } else {
                      setState(() {
                        _errorMessage = null;
                      });
                      return null;
                    }
                  },
                ),
                Consumer<SellProductProvider>(
                  builder: (context, provider, child) {
                    double? price = provider.price;
                    if (price != null && price >= 10) {
                      double earnings = price * 0.8;
                      return Text(
                        "Vous gagnez en cas de vente : ${earnings.toStringAsFixed(2)} Dinars",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 14,
                            fontFamily: "Raleway"),
                      );
                    }
                    return const SizedBox(); // Cache le texte si le prix est invalide
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                if (subcategory.startsWith("C") && category != "CRA") ...[
                  CustomTextFormField(
                    controller: _pointureController,
                    label: "Pointure",
                    isPassword: false,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _errorMessage = "pointure obligatoire";
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
                if (widget.categoryFromMv != null &&
                    !subcategory.startsWith("C")) ...[
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
                    label: "Marque",
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
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
                if (widget.categoryFromMv != null)
                  CustomDropdownFormField(
                    imageMenu: true,
                    colors: colors,
                    pathImagesForsmenu: [""],
                    options: [
                      {'multicolores': 'Multicolores'},
                      {'noir': 'Noir'},
                      {'blanc': 'Blanc'},
                      {'gris': 'Gris'},
                      {'doré': 'Doré'},
                      {'argent': 'Argent'},
                      {'rouge': 'Rouge'},
                      {'bleu': 'Bleu'},
                      {'jaune': 'Jaune'},
                      {'vert': 'Vert'},
                      {'turquoise': 'Turquoise'},
                      {'vert_eau': 'Vert d\'eau'},
                      {'beige': 'Beige'},
                      {'marron': 'Marron'},
                      {'camel': 'Camel'},
                      {'orange': 'Orange'},
                      {'corail': 'Corail'},
                      {'rose': 'Rose'},
                      {'violet': 'Violet'},
                      {'bordeaux': 'Bordeaux'},
                      {'rose_poudré': 'Rose poudré'},
                      {'nude': 'Nude'},
                      {'bleu_marine': 'Bleu marine'},
                      {'kaki': 'Kaki'},
                      {'vert_fonce': 'Vert foncé'},
                    ],
                    label: "Choisir la couleur",
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          _colorController.text = value;
                        } else {
                          _colorController.text = "color";
                        }
                      });
                    },
                  ),
                SizedBox(
                  height: 16,
                ),
                if (category == "D" ||
                    category == "OV" ||
                    (category == "CRA" && subcategory != "HAUCO")) ...[
                  CustomTextFormField(
                    controller: _longeurController,
                    label: 'Longeur en cm',
                    isPassword: false,
                    keyboardType:
                        TextInputType.number, // ✅ Définit le clavier numérique
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // ✅ N'accepte que les chiffres
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La longueur est obligatoire';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextFormField(
                      controller: _largeurController,
                      label: 'Largeur en cm',
                      keyboardType:
                        TextInputType.number, // ✅ Définit le clavier numérique
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                      isPassword: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _errorMessage = "Largeur obligatoire";
                          return 'la Largeur est obligatoire';
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
                  CustomTextFormField(
                      controller: _hauteurController,
                      label: 'Hauteur en cm',
                      keyboardType:
                        TextInputType.number, // ✅ Définit le clavier numérique
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                      isPassword: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _errorMessage = "Hauteur obligatoire";
                          return 'la Hauteur est obligatoire';
                        } else {
                          setState(() {
                            _errorMessage = null;
                          });
                          return null;
                        }
                      }),
                  SizedBox(
                    height: 16,
                  ),
                ],
                if (category == "CRA" && subcategory == "HAUCO") ...[
                  CustomTextFormField(
                      controller: _tailleController,
                      label: 'taille',
                      isPassword: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _errorMessage = "taille obligatoire";
                          return 'la taille est obligatoire';
                        } else {
                          setState(() {
                            _errorMessage = null;
                          });
                          return null;
                        }
                      }),
                ],

                const SizedBox(
                  height: 24,
                ),
                // if (_errorMessage != null)
                //   Text(
                //     "$_errorMessage",
                //     style: TextStyle(color: Colors.red, fontFamily: "Raleway"),
                //   ),
                CustomButton(
                  buttonColor:
                      _Loading ? const Color(0xffE5E7EB) : Colors.black,
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
                              int.tryParse(_priceController.text) != null &&
                              int.parse(_priceController.text) >= 10 &&
                              _titleController.text.isNotEmpty &&
                              _descriptionController.text.isNotEmpty &&
                              _categoryController.text.isNotEmpty) {
                            double? price =
                                double.tryParse(_priceController.text);
                            int? quantity =
                                int.tryParse(_quantityController.text);
                            print(
                                "heeeeeeeeeeeeey $subCategoryOrSubsubcategory");
                            final bool result = await Provider.of<Products>(
                                    context,
                                    listen: false)
                                .sellProduct(
                              _colorController.text,
                              _titleController.text,
                              _descriptionController.text,
                              subcategory.isNotEmpty
                                  ? subcategory
                                  : widget.categoryFromMv!,
                              price!,
                              _possibleDeffectsController.text,
                              _tailleController.text,
                              _pointureController.text,
                              _etatController.text,
                              _brandController.text,
                              _dimensionController.text,
                              Provider.of<SellProductProvider>(context,
                                      listen: false)
                                  .images,
                              _hauteurController.text,
                              _largeurController.text,
                              _longeurController.text,
                            );
                            if (result) {
                              setState(() {
                                _Loading = false;
                                Provider.of<SellProductProvider>(context,
                                        listen: false)
                                    .reset();
                              });
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemSubmitted(),
                                ),
                                (route) => false,
                              );
                            } else {
                              setState(() {
                                _errorMessage = Provider.of<Products>(context,
                                        listen: false)
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
                              _descriptionController.text.isNotEmpty) {
                            double? price =
                                double.tryParse(_priceController.text);
                            int? quantity =
                                int.tryParse(_quantityController.text);
                            print(
                                "heeeeeeeeeeeeey $subCategoryOrSubsubcategory");
                            final http.StreamedResponse result =
                                await Provider.of<Products>(context,
                                        listen: false)
                                    .updateProduct(
                              widget.product["id"],
                              _titleController.text,
                              _descriptionController.text,
                              widget.product[
                                  "backend_category"], // Sous-catégorie obtenue depuis Navigator.push
                              price!,
                              _possibleDeffectsController.text,
                              _tailleController.text,
                              _pointureController.text,
                              _etatController.text,
                              _brandController.text,
                              Provider.of<SellProductProvider>(context,
                                      listen: false)
                                  .images,
                            );
                            if (result.statusCode == 200) {
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
                            } else if (result.statusCode == 488) {
                              // Si une erreur survient, récupérer et afficher le message d'erreur
                              setState(() {
                                _errorMessage =
                                    "vous ne pouvez pas augmenter le prix";
                              });
                              setState(() {
                                _Loading = false;
                              });
                            } else {
                              setState(() {
                                _errorMessage = Provider.of<Products>(context,
                                        listen: false)
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
            ]),
          ),
        ),
      ),
    );
  }
}
