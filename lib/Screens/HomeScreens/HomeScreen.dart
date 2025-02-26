import 'dart:io';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/HomeScreens/cart.dart';
import 'package:finesse_frontend/Screens/HomeScreens/story.dart';
import 'package:finesse_frontend/Screens/HomeScreens/wish.dart';
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
      Provider.of<Products>(context, listen: false).getRatingByRatedUser(
          userId:
              Provider.of<AuthService>(context, listen: false).currentUser!.id);
    });
    Provider.of<Stories>(context, listen: false).fetchFollowersAndStories(
        userId:
            Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Products>(context, listen: false).getProductsByUser();
    Provider.of<Products>(context, listen: false).getFavourite(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Products>(context, listen: false).getFollowers(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Products>(context, listen: false).getWish(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
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
                            ? "Bienvenue ${user.username}"
                            : 'Bienvenue, ${user.fullName.split(' ')[0]}',
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WishList()));
                        },
                        child: SvgPicture.asset(
                          "assets/Icons/heartt.svg",
                          height: 18,
                          width: 18,
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cart()));
                          },
                          child: SvgPicture.asset("assets/Icons/favv.svg")),
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
                  child: Consumer<Stories>(
                    builder: (context, storiesProvider, child) {
                      final stories = storiesProvider.stories;
                      Map<String, List<Map<String, dynamic>>> groupedStories =
                          {};
                      for (var story in stories) {
                        String username = story['user'];
                        if (!groupedStories.containsKey(username)) {
                          groupedStories[username] = [];
                        }
                        groupedStories[username]!.add(story);
                      }
                      return Row(
                        children: [
                          // Ajout de la story de l'utilisateur actuel
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.blue, width: 2),
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
                                    ),
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
                                              userId: await storage.read(
                                                  key: 'user_id'),
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                              color: Colors.white, width: 2),
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
                              ),
                            ],
                          ),
                          const SizedBox(
                              width:
                                  10), // Espace entre le profil et les stories

                          // Affichage des autres stories importées
                          Row(
      children: groupedStories.entries.map((entry) {
        String username = entry.key;
        List<Map<String, dynamic>> userStories = entry.value;
        Map<String, dynamic> firstStory = userStories.first;

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryViewScreen(stories: userStories),
                ),
              );
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: (firstStory['avatar'] != null)
                            ? firstStory["avatar_type"] == "normal"
                                ? NetworkImage("${AppConfig.baseUrl}/${firstStory['avatar']}")
                                : NetworkImage(firstStory['avatar'])
                            : const AssetImage('assets/images/user.png') as ImageProvider,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    // Afficher un indicateur si plusieurs stories
                    if (userStories.length > 1)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.collections,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  username,
                  style: const TextStyle(
                    color: Color(0xFF0E1C36),
                    fontSize: 12,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
                        ],
                      );
                    },
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
                      text: "Tout",
                      isSelected: selectedCategory == "All",
                      onTap: () {
                        setState(() {
                          selectedCategory = "All";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/tab.svg",
                      text: "Tableaux",
                      isSelected: selectedCategory == "Tableaux",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Tableaux";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/scul.svg",
                      text: "Sculptures",
                      isSelected: selectedCategory == "Sculptures",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Sculptures";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/deco.svg",
                      text: "Decoration",
                      isSelected: selectedCategory == "D",
                      onTap: () {
                        setState(() {
                          selectedCategory = "D";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/art.svg",
                      text: "Art graphiques",
                      isSelected: selectedCategory == "Art graphiques",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Art graphiques";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/vet.svg",
                      text: "Mode et vintage",
                      isSelected: selectedCategory == "Mode et vintage",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Mode et vintage";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/montre.svg",
                      text: "Montres et Bijoux",
                      isSelected: selectedCategory == "Montres et Bijoux",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Montres et Bijoux";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/mona-lisa.svg",
                      text: "Arts de la table",
                      isSelected: selectedCategory == "Arts de la table",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Arts de la table";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/bookk.svg",
                      text: "Livres",
                      isSelected: selectedCategory == "Livres",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Livres";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/Icons/jeu.svg",
                      text: "Jouets",
                      isSelected: selectedCategory == "Jouets",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Jouets";
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
                      'type': "Récemment consulté",
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
                      'taille': product['taille'],
                      'pointure': product['pointure'],
                      'brand': product['brand'],
                      'selled': product["selled"],
                      'type_pdp': product["type"],
                      'owner_id': product["owner"]["id"],
                      'is_favorite': product['is_favorite'],
                      'owner_profile_pic':
                          product["owner"]["profile_pic"] ?? "",
                      'owner_username': product["owner"]["username"] ?? "",
                      'owner_ratings': product["owner"]["ratings"] ?? "",
                      'comments': product['comments']
                              ?.map((comment) => {
                                    'username':
                                        comment['username'] ?? 'Unknown',
                                    'avatar': comment['avatar'] ?? '',
                                    'content': comment['content'] ?? '',
                                    'created_at': comment['created_at'] ?? '',
                                  })
                              .toList() ??
                          [], // Ajout des commentaires ici
                    },
                  ),
                  ...productsProvider.products.map(
                    (product) => {
                      'type': 'Pour vous',
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
                      'taille': product['taille'],
                      'is_favorite': product['is_favorite'],
                      'pointure': product['pointure'],
                      'selled': product["selled"],
                      'brand': product['brand'],
                      'owner_id': product["owner"]["id"],
                      'type_pdp': product["type"],
                      'owner_profile_pic':
                          product["owner"]["profile_pic"] ?? "",
                      'owner_username': product["owner"]["username"] ?? "",
                      'owner_ratings': product["owner"]["ratings"] ?? "",
                      'comments': product['comments']
                              ?.map((comment) => {
                                    'username':
                                        comment['username'] ?? 'Unknown',
                                    'avatar': comment['avatar'] ?? '',
                                    'content': comment['content'] ?? '',
                                    'created_at': comment['created_at'] ?? '',
                                  })
                              .toList() ??
                          [], // Ajout des commentaires ici
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
                                onTap: product["selled"] == true
                                    ? () {}
                                    : () {
                                        productsProvider
                                            .createRecentlyViewedProducts(
                                          productId: product["product_id"],
                                        );
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
                                child: Stack(
                                  children: [
                                    ProductCard(
                                      imageUrl: product['imageUrl'] as String,
                                      productName:
                                          product['productName'] as String,
                                      productPrice:
                                          product['productPrice'] as String,
                                    ),
                                    if (product["selled"] ==
                                        true) // Vérifie si le produit est vendu
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                        bottom: 100,
                                        child: Center(
                                          // Centre le badge dans le conteneur parent
                                          child: Transform.rotate(
                                            angle:
                                                -0.1, // Angle pour incliner le badge
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(
                                                    0.7), // Couleur rouge avec opacité
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // Coins arrondis
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Vendu',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      18, // Ajustement de la taille du texte
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
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
