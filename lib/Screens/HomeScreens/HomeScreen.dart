import 'dart:io';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/SellProduct/itemDetails.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:finesse_frontend/Widgets/categorieChip/categoryChip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String? parameter;
  const HomeScreen({Key? key, required this.parameter}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();
  XFile? _image;

  String selectedCategory = "All"; // Par défaut, afficher tous les produits

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.parameter == "normal") {
        Provider.of<AuthService>(context, listen: false).loadUserData();
      } else {
        Provider.of<AuthService>(context, listen: false).loadUserGoogleData();
      }
    });
    Provider.of<Products>(context, listen: false).getProductsByUser();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;
    final allProductss = [
      ...Provider.of<Products>(context, listen: false).productsView.map(
            (product) => {
              'type': 'Recently Viewed',
              'subcategory': product['subcategory'] ?? 'Unknown', // Catégorie
              'imageUrl':
                  "${AppConfig.baseUrl}/${product['images'][0]}".isNotEmpty
                      ? "${AppConfig.baseUrl}/${product['images'][0]}"
                      : 'assets/images/test1.png',
              'productName': product['title'] ?? 'Unknown Product',
              'productPrice': "${product['price']} TND".toString(),
              'product_id': "${product['id']}"
            },
          ),
      ...Provider.of<Products>(context, listen: false).products.map(
            (product) => {
              'type': 'For You',
              'category': product['category'] ?? 'Unknown',
              'subcategory': product['subcategory'] ?? 'Unknown',
              'imageUrl':
                  "${AppConfig.baseUrl}/${product['images'][0]}".isNotEmpty
                      ? "${AppConfig.baseUrl}/${product['images'][0]}"
                      : 'assets/images/test1.png',
              'productName': product['title'] ?? 'Unknown Product',
              'productPrice': "${product['price']} TND".toString(),
              'product_id': "${product['id']}"
            },
          ),
    ];
    final filteredProducts = selectedCategory == "All"
        ? allProductss
        : allProductss
            .where((product) => product['category'] == selectedCategory)
            .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // En-tête
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            (user.avatar != "" && user.avatar != null)
                                ? NetworkImage(widget.parameter == "normal"
                                    ? "${AppConfig.baseUrl}${user.avatar}"
                                    : user.avatar!)
                                : const AssetImage('assets/images/user.png')
                                    as ImageProvider,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        user.fullName == "None None"
                            ? "Hello ${user.username}"
                            : 'Hello, ${user.fullName.split(' ')[0]}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(
                          "assets/Icons/heartt.svg",
                          height: 18,
                          width: 18,
                        ),
                      ),
                      const SizedBox(width: 20),
                      SvgPicture.asset("assets/Icons/favv.svg"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 10),
              child: Container(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Consumer<Stories>(
                            builder: (context, stories, child) {
                              bool hasStory = stories.hasStory;

                              return Column(
                                children: [
                                  Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: hasStory
                                          ? Border.all(
                                              color: Colors.blue, width: 2)
                                          : null,
                                    ),
                                    child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: (user.avatar != "" &&
                                              user.avatar != null)
                                          ? NetworkImage(widget.parameter ==
                                                  "normal"
                                              ? "${AppConfig.baseUrl}${user.avatar}"
                                              : user.avatar!)
                                          : AssetImage('assets/images/user.png')
                                              as ImageProvider,
                                      backgroundColor: Colors.transparent,
                                      child: user.avatar == null
                                          ? Container()
                                          : null,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    user.fullName == "None None"
                                        ? user.username
                                        : user.fullName,
                                    style: TextStyle(
                                      color: Color(0xFF0E1C36),
                                      fontSize: 12,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                await _pickImage();
                                if (_image != null) {
                                  try {
                                    await Provider.of<Stories>(context,
                                            listen: false)
                                        .createStory(
                                      userId:
                                          await storage.read(key: 'user_id'),
                                      storyImage: _image,
                                    );
                                    print("Story créée avec succès !");
                                  } catch (e) {
                                    print(
                                        "Erreur lors de la création de la story : $e");
                                  }
                                } else {
                                  print(
                                      "Aucune image sélectionnée. Veuillez en choisir une.");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Veuillez sélectionner une image pour créer une story."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryChip(
                      text: "All",
                      isSelected: selectedCategory == "All",
                      onTap: () {
                        setState(() {
                          selectedCategory = "All";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Art and creation",
                      isSelected: selectedCategory == "AC",
                      onTap: () {
                        setState(() {
                          selectedCategory = "AC";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Decoration",
                      isSelected: selectedCategory == "D",
                      onTap: () {
                        setState(() {
                          selectedCategory = "D";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Vetements",
                      isSelected: selectedCategory == "Vetements",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Vetements";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Jouets",
                      isSelected: selectedCategory == "Jouets",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Jouets";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Bijoux",
                      isSelected: selectedCategory == "Bijoux",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Bijoux";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Chaussures",
                      isSelected: selectedCategory == "Chaussures",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Chaussures";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Accessoires",
                      isSelected: selectedCategory == "Accessoires",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Accessoires";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Sacs",
                      isSelected: selectedCategory == "Sacs",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Sacs";
                        });
                      },
                    ),
                    CategoryChip(
                      text: "Produits de beauté",
                      isSelected: selectedCategory == "Produits de beauté",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Produits de beauté";
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Consumer<Products>(
              builder: (context, productsProvider, child) {
                final allProducts = [
                  ...productsProvider.productsView.map(
                    (product) => {
                      'type': 'Recently Viewed',
                      'subcategory': product['subcategory'] ?? 'Unknown',
                      'imageUrl': "${AppConfig.baseUrl}/${product['images'][0]}"
                              .isNotEmpty
                          ? "${AppConfig.baseUrl}/${product['images'][0]}"
                          : 'assets/images/test1.png',
                      'images':
                          product['images'] ?? [], // Liste complète des images
                      'productName': product['title'] ?? 'Unknown Product',
                      'productPrice': "${product['price']} TND".toString(),
                      'product_id': "${product['id']}",
                      'description': product['description'] ?? '',
                      'is_available': product['is_available'] ?? false,
                      'category': product['category'] ?? 'Unknown',
                      'taille' : product['taille'],
                      'pointure' : product['pointure'],
                      'brand' : product['brand'],
                      'owner_profile_pic' : product["owner"]["profile_pic"] ?? "",
                      'owner_username' : product["owner"]["username"] ?? "",
                      'owner_ratings' : product["owner"]["ratings"] ?? "",
                    },
                  ),
                  ...productsProvider.products.map(
                    (product) => {
                      'type': 'For You',
                      'category': product['category'] ?? 'Unknown',
                      'subcategory': product['subcategory'] ?? 'Unknown',
                      'imageUrl': "${AppConfig.baseUrl}/${product['images'][0]}"
                              .isNotEmpty
                          ? "${AppConfig.baseUrl}/${product['images'][0]}"
                          : 'assets/images/test1.png',
                      'images':
                          product['images'] ?? [], // Liste complète des images
                      'productName': product['title'] ?? 'Unknown Product',
                      'productPrice': "${product['price']} TND".toString(),
                      'product_id': "${product['id']}",
                      'description': product['description'] ?? '',
                      'is_available': product['is_available'] ?? false,
                      'taille' : product['taille'],
                      'pointure' : product['pointure'],
                      'brand' : product['brand'],
                      'owner_profile_pic' : product["owner"]["profile_pic"] ?? "",
                      'owner_username' : product["owner"]["username"] ?? "",
                      'owner_ratings' : product["owner"]["ratings"] ?? "",
                    },
                  ),
                ];

                final filteredProducts = selectedCategory == "All"
                    ? allProducts
                    : allProducts
                        .where((product) =>
                            product['category'] == selectedCategory)
                        .toList();

                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
                    itemCount:
                        filteredProducts.map((e) => e['type']).toSet().length,
                    itemBuilder: (context, categoryIndex) {
                      final categoryType = filteredProducts
                          .map((e) => e['type'])
                          .toSet()
                          .toList()[categoryIndex];
                      final categoryProducts = filteredProducts
                          .where((product) => product['type'] == categoryType)
                          .toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 8.0, top: 16.0),
                            child: Text(
                              categoryType as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Raleway',
                              ),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 0.0,
                              childAspectRatio: 3 / 4,
                            ),
                            itemCount: categoryProducts.length,
                            itemBuilder: (context, index) {
                              final product = categoryProducts[index];
                              return InkWell(
                                onTap: () {
                                  productsProvider.createRecentlyViewedProducts(
                                      productId: product["product_id"]);
                                  productsProvider.getProductsViewed();

                                  // Naviguer vers la page ItemDetails avec toutes les infos du produit
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ItemDetails(product: product),
                                    ),
                                  );
                                },
                                child: ProductCard(
                                  imageUrl: product['imageUrl'] as String,
                                  productName: product['productName'] as String,
                                  productPrice:
                                      product['productPrice'] as String,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
