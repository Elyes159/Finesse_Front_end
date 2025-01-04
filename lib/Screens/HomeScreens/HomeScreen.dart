import 'dart:io';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
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

    // Liste combinée des produits
    final products = [
      ...List.generate(
        10,
        (index) => {
          'type': 'Recently viewed',
          'imageUrl': 'assets/images/test1.png',
          'productName': 'Recently ${index + 1}',
          'productPrice': '${(index + 1) * 10}'
        },
      ),
      ...List.generate(
        10,
        (index) => {
          'type': 'For You',
          'imageUrl': 'assets/images/test2.png',
          'productName': 'For You ${index + 1}',
          'productPrice': '${(index + 1) * 15}'
        },
      ),
    ];

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
                        'Hello, ${user.fullName.split(' ')[0]}',
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
                alignment:
                    Alignment.topLeft, // Place le contenu en haut à gauche
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                              color: Colors.blue,
                                              width:
                                                  2) // Bordure bleue si hasStory est true
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
                                      child:
                                          user.avatar == null ? Container() : null,
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  Text(
                                      user.fullName,
                                      style: TextStyle(
                                          color: Color(0xFF0E1C36),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
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
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 2), // Bordure blanche
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
            SizedBox(height: 13,),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                itemCount: products
                    .map((e) => e['type'])
                    .toSet()
                    .length, // Nombre de catégories uniques
                itemBuilder: (context, categoryIndex) {
                  final categoryType = products
                      .map((e) => e['type'])
                      .toSet()
                      .toList()[categoryIndex];
                  final categoryProducts = products
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
                        shrinkWrap:
                            true, // Permet à la grille de s'adapter à son contenu
                        physics:
                            const NeverScrollableScrollPhysics(), // Désactive le défilement interne
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: categoryProducts.length,
                        itemBuilder: (context, index) {
                          final product = categoryProducts[index];
                          return ProductCard(
                            imageUrl: product['imageUrl'] as String,
                            productName: product['productName'] as String,
                            productPrice: product['productPrice'] as String,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
