import 'dart:io';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Provider/virement.dart';
import 'package:finesse_frontend/Screens/HomeScreens/cart.dart';
import 'package:finesse_frontend/Screens/HomeScreens/story.dart';
import 'package:finesse_frontend/Screens/HomeScreens/wish.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/orders.dart';
import 'package:finesse_frontend/Screens/SellProduct/itemDetails.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:finesse_frontend/Widgets/categorieChip/categoryChip.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String? parameter;
  const HomeScreen({super.key, required this.parameter});

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
    Provider.of<AuthService>(context, listen: false).fetchSellingOrders(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Products>(context, listen: false).getProductsSelledByUser();
    Provider.of<Products>(context, listen: false).getFavourite(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Products>(context, listen: false).getFollowers(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Products>(context, listen: false).getFollowing(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Products>(context, listen: false).getWish(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Profileprovider>(context, listen: false).getArtistsIds(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<Products>(context, listen: false).fetchMembers();
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
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileMain()));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              (user.avatar != "" && user.avatar != null)
                                  ? NetworkImage(widget.parameter == "normal" ||
                                          widget.parameter == "apple"
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
                          color: theme ? Colors.white : null,
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Orders()));
                        },
                        child: SvgPicture.asset(
                          "assets/Icons/sac.svg",
                          height: 20,
                          width: 18,
                          color: theme ? Colors.white : null,
                        ),
                      ),
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
                                          color: theme
                                              ? Color.fromARGB(
                                                  255, 249, 217, 144)
                                              : Colors.blue,
                                          width: 2),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: (user.avatar != "" &&
                                              user.avatar != null)
                                          ? NetworkImage(widget.parameter ==
                                                      "normal" ||
                                                  widget.parameter == "apple"
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
                                          color: theme
                                              ? Color.fromARGB(
                                                  255, 249, 217, 144)
                                              : Colors.blue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: theme
                                              ? Colors.black
                                              : Colors.white,
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
                                  color:
                                      theme ? Colors.white : Color(0xFF0E1C36),
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
                              List<Map<String, dynamic>> userStories =
                                  entry.value;
                              Map<String, dynamic> firstStory =
                                  userStories.first;

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoryViewScreen(
                                            stories: userStories),
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
                                                color: theme
                                                    ? Color.fromARGB(
                                                        255, 249, 217, 144)
                                                    : Colors.blue,
                                                width: 2,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage: (firstStory[
                                                          'avatar'] !=
                                                      null)
                                                  ? firstStory["avatar_type"] ==
                                                          "normal"
                                                      ? NetworkImage(
                                                          "${AppConfig.baseUrl}/${firstStory['avatar']}")
                                                      : NetworkImage(
                                                          firstStory['avatar'])
                                                  : const AssetImage(
                                                          'assets/images/user.png')
                                                      as ImageProvider,
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                          // Afficher un indicateur si plusieurs stories
                                          if (userStories.length > 1)
                                            Positioned(
                                              bottom: 2,
                                              right: 2,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
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
                                      SizedBox(height: 3),
                                      Text(
                                        username,
                                        style: TextStyle(
                                          color: theme
                                              ? Colors.white
                                              : Color(0xFF0E1C36),
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
                      iconPath: "assets/images/tableau.jpeg",
                      text: "Tableaux",
                      isSelected: selectedCategory == "Tableaux",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Tableaux";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/images/scul.jpeg",
                      text: "Sculptures",
                      isSelected: selectedCategory == "Sculptures",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Sculptures";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/images/d.jpg",
                      text: "Decoration",
                      isSelected: selectedCategory == "D",
                      onTap: () {
                        setState(() {
                          selectedCategory = "D";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/images/graph.jpeg",
                      text: "Art graphiques",
                      isSelected: selectedCategory == "Art graphiques",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Art graphiques";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/images/mv.jpeg",
                      text: "Mode et vintage",
                      isSelected: selectedCategory == "Mode et vintage",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Mode et vintage";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/images/mb.jpeg",
                      text: "Montres et Bijoux",
                      isSelected: selectedCategory == "Montres et Bijoux",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Montres et Bijoux";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/images/att.jpg",
                      text: "Arts de la table",
                      isSelected: selectedCategory == "Arts de la table",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Arts de la table";
                        });
                      },
                    ),
                    CategoryChip(
                      iconPath: "assets/images/livre.jpeg",
                      text: "Livres",
                      isSelected: selectedCategory == "Livres",
                      onTap: () {
                        setState(() {
                          selectedCategory = "Livres";
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
                /// Fonction pour convertir la date envoyée par Django en `DateTime` Dart
                /// Fonction pour convertir la date ISO 8601 envoyée par Django en `DateTime`
                DateTime? parseDjangoDate(String? djangoDate) {
                  if (djangoDate == null || djangoDate.isEmpty) return null;
                  try {
                    // Assurez-vous que la date est dans un format compatible.
                    return DateTime.parse(djangoDate).toLocal();
                  } catch (e) {
                    print(
                        "❌ Erreur lors de la conversion de la date : $djangoDate");
                    return null;
                  }
                }

                final artistList =
                    Provider.of<Profileprovider>(context, listen: false)
                        .artistsList;
                print("artistList: $artistList");

                final now = DateTime.now();
                final sixDaysAgo =
                    now.subtract(Duration(days: 6)); // 6 derniers jours

                print("📅 Date actuelle: $now");
                print("📅 Date il y a 6 jours: $sixDaysAgo");

                final thisWeekProducts = [
                  ...productsProvider.products.where((product) {
                    final productDate = parseDjangoDate(product['date']);
                    if (productDate == null) {
                      print(
                          "🔴 Date invalide pour le produit: ${product['title']}");
                      return false;
                    }

                    print(
                        "✅ Produit trouvé : ${product['title']} avec la date $productDate");

                    final productDateOnly = DateTime(
                        productDate.year, productDate.month, productDate.day);
                    print(
                        "🕒 Comparaison de la date du produit: $productDateOnly");

                    // Vérification si la date du produit est dans les 6 derniers jours
                    if (productDateOnly.isAfter(sixDaysAgo) &&
                        productDateOnly.isBefore(now)) {
                      print("✅ Ce produit est dans les 6 derniers jours !");
                      return true;
                    } else {
                      print(
                          "❌ Ce produit n'est pas dans les 6 derniers jours.");
                      return false;
                    }
                  }).map((product) => {
                        'type': "Nouveautés",
                        'subcategory': product['subcategory'] ?? 'Unknown',
                        'imageUrl': (product['images'] != null &&
                                product['images'].isNotEmpty)
                            ? "${AppConfig.baseUrl}${product['images'][0]}"
                            : 'assets/images/test1.png',
                        'images': product['images'] ?? [],
                        'productName': product['title'] ?? 'Unknown Product',
                        'productPrice': "${product['price']}",
                        'product_id': "${product['id']}",
                        'description': product['description'] ?? '',
                        'is_available': product['is_available'] ?? false,
                        'category': product['category'] ?? 'Unknown',
                        'taille': product['taille'],
                        'color': product["color"],
                        'pointure': product['pointure'],
                        'brand': product['brand'],
                        'selled': product["selled"],
                        'type_pdp': product["type"],
                        "longeur": product["longeur"],
                        "hauteur": product["hauteur"],
                        "largeur": product["largeur"],
                        "created": product["created"],
                        'owner_id': product["owner"]["id"],
                        'is_favorite': product['is_favorite'],
                        'owner_profile_pic':
                            product["owner"]["profile_pic"] ?? "",
                        'owner_username': product["owner"]["username"] ?? "",
                        'owner_ratings': product["owner"]["ratings"] ?? "",
                        'comments': (product['comments'] as List?)
                                ?.map((comment) => {
                                      'username':
                                          comment['username'] ?? 'Unknown',
                                      'avatar': comment['avatar'] ?? '',
                                      'content': comment['content'] ?? '',
                                      'created_at': comment['created_at'] ?? '',
                                    })
                                .toList() ??
                            [],
                      }),
                ];

                if (kDebugMode) {
                  print(
                      "📦 Produits filtrés pour les 6 derniers jours: ${thisWeekProducts.length}");
                }

                final allProducts = [
                  ...thisWeekProducts,
                  ...productsProvider.productsView.map(
                    (product) => {
                      'type': "Récemment consulté",
                      'subcategory': product['subcategory'] ?? 'Unknown',
                      'imageUrl': "${AppConfig.baseUrl}${product['images'][0]}"
                              .isNotEmpty
                          ? "${AppConfig.baseUrl}${product['images'][0]}"
                          : 'assets/images/test1.png',
                      'images':
                          product['images'] ?? [], // Liste complète des images
                      'productName': product['title'] ?? 'Unknown Product',
                      'productPrice': "${product['price']}".toString(),
                      'product_id': "${product['id']}",
                      'description': product['description'] ?? '',
                      'is_available': product['is_available'] ?? false,
                      'category': product['category'] ?? 'Unknown',
                      'taille': product['taille'],
                      'pointure': product['pointure'],
                      'brand': product['brand'],
                      "longeur": product["longeur"],
                      "hauteur": product["hauteur"],
                      'etat': product["etat"],
                      'color': product["color"],
                      "largeur": product["largeur"],
                      'selled': product["selled"],
                      "created": product["created"],
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
                  ...productsProvider.productsArt.map(
                    (product) => {
                      'type': "Coin artistique",
                      'subcategory': product['subcategory'] ?? 'Unknown',
                      'imageUrl': "${AppConfig.baseUrl}${product['images'][0]}"
                              .isNotEmpty
                          ? "${AppConfig.baseUrl}${product['images'][0]}"
                          : 'assets/images/test1.png',
                      'images':
                          product['images'] ?? [], // Liste complète des images
                      'productName': product['title'] ?? 'Unknown Product',
                      'productPrice': "${product['price']}".toString(),
                      'product_id': "${product['id']}",
                      'description': product['description'] ?? '',
                      'is_available': product['is_available'] ?? false,
                      'category': product['category'] ?? 'Unknown',
                      'taille': product['taille'],
                      'pointure': product['pointure'],
                      'color': product["color"],
                      "created": product["created"],
                      'brand': product['brand'],
                      "longeur": product["longeur"],
                      "hauteur": product["hauteur"],
                      "largeur": product["largeur"],
                      'selled': product["selled"],
                      'etat': product["etat"],
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
                  ...productsProvider.products
                      .map(
                        (product) => {
                          'type': 'Pour vous',
                          'category': product['category'] ?? 'Unknown',
                          'subcategory': product['subcategory'] ?? 'Unknown',
                          'imageUrl':
                              "${AppConfig.baseUrl}${product['images'][0]}"
                                      .isNotEmpty
                                  ? "${AppConfig.baseUrl}${product['images'][0]}"
                                  : 'assets/images/test1.png',
                          'images': product['images'] ?? [],
                          'productName': product['title'] ?? 'Unknown Product',
                          'productPrice': "${product['price']}".toString(),
                          'product_id': "${product['id']}",
                          'description': product['description'] ?? '',
                          'is_available': product['is_available'] ?? false,
                          'taille': product['taille'],
                          'etat': product["etat"],
                          "created": product["created"],
                          'is_favorite': product['is_favorite'],
                          'pointure': product['pointure'],
                          'selled': product["selled"],
                          'brand': product['brand'],
                          'owner_id': product["owner"]["id"],
                          'type_pdp': product["type"],
                          'color': product["color"],
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
                                        'created_at':
                                            comment['created_at'] ?? '',
                                      })
                                  .toList() ??
                              [],
                        },
                      )
                      .where((product) =>
                          artistList.contains(product["owner_id"])),
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
                      if (categoryIndex == 2) {
                        // Choisir l'emplacement où ajouter un widget (ici après la première catégorie)
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Artiste à suivre",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Raleway',
                              ),
                            ),
                            Container(
                              height:
                                  200, // Ajuste la hauteur selon tes besoins
                              child: Builder(
                                builder: (context) {
                                  final filteredMembers = productsProvider
                                      .members
                                      .where((member) =>
                                          member["artiste_artisan"] == true)
                                      .toList();

                                  if (filteredMembers.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    scrollDirection: Axis
                                        .horizontal, // Défilement horizontal
                                    itemCount: filteredMembers.length,
                                    itemBuilder: (context, index) {
                                      final member = filteredMembers[index];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                10), // Espacement entre les éléments
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                // Navigation vers le profil du membre
                                                await Provider.of<
                                                            Profileprovider>(
                                                        context,
                                                        listen: false)
                                                    .fetchProfile(member["id"]);
                                                await Provider.of<Products>(
                                                        context,
                                                        listen: false)
                                                    .getProductsByUserVisited(
                                                        member["id"]);
                                                await Provider.of<Products>(
                                                        context,
                                                        listen: false)
                                                    .getProductsSelledByUserVisited(
                                                        member["id"]);
                                                await Provider.of<Products>(
                                                        context,
                                                        listen: false)
                                                    .getRatingByRatedUserVisited(
                                                        userId: member["id"]);
                                                await Provider.of<Products>(
                                                        context,
                                                        listen: false)
                                                    .checkOrderedorNot(
                                                        first_id: Provider.of<
                                                                    AuthService>(
                                                                context,
                                                                listen: false)
                                                            .currentUser!
                                                            .id,
                                                        second_id:
                                                            member["id"]);
                                                await Provider.of<Products>(
                                                        context,
                                                        listen: false)
                                                    .getFollowersVisited(
                                                        member["id"]);
                                                await Provider.of<Products>(
                                                        context,
                                                        listen: false)
                                                    .getFollowingVisited(
                                                        member["id"]);

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileMain(
                                                              id: member[
                                                                  "id"])),
                                                );
                                              },
                                              child: CircleAvatar(
                                                radius:
                                                    30, // Taille de l'avatar
                                                backgroundImage: NetworkImage(
                                                  member["image_type"] ==
                                                          "normal"
                                                      ? "${AppConfig.baseUrl}${member['avatar'] ?? ''}"
                                                      : (member["avatar"] ??
                                                          ''),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    8), // Espacement entre l'avatar et le texte
                                            Text(
                                              member['full_name'] ??
                                                  'Art zi user',
                                              style: TextStyle(
                                                  fontFamily: "Raleway",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
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
