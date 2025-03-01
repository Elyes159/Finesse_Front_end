import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/Profile/Settings.dart';
import 'package:finesse_frontend/Screens/SellProduct/SellproductScreen.dart';
import 'package:finesse_frontend/Screens/SellProduct/itemDetails.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:finesse_frontend/Widgets/rating/ratingpercen.dart';
import 'package:finesse_frontend/Widgets/rating/star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileMain extends StatefulWidget {
  int? id;
  ProfileMain({super.key, this.id});

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  String? parametre = "";
  int selectedRating = 0;
  int _selectedTabIndex = 0;
  TextEditingController reviewController = TextEditingController();
  String? errormsg; // Onglet actuellement sélectionné

  Future<void> _loadParameter() async {
    parametre = await const FlutterSecureStorage().read(key: 'parametre');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadParameter();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final user = widget.id == null
        ? Provider.of<AuthService>(context, listen: false).currentUser!
        : Provider.of<Profileprovider>(context, listen: false).visitedProfile!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: (user.avatar != "" && user.avatar != null)
                        ? NetworkImage(parametre == "normal"
                            ? widget.id == null
                                ? "${AppConfig.baseUrl}${user.avatar}"
                                : "${user.avatar}"
                            : user.avatar!)
                        : AssetImage('assets/images/user.png') as ImageProvider,
                    backgroundColor: Colors.transparent,
                    child: user.avatar == null
                        ? const CircularProgressIndicator()
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.id == null ? user.fullName : user.username,
                        style: TextStyle(
                          //color: Color(0xFF111928),
                          fontSize: 20,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.id == null
                            ? '${Provider.of<Products>(context, listen: false).nbfollowers ?? "0"} Abonnés'
                            : '${Provider.of<Products>(context, listen: false).nbfollowervisited} Abonnés',
                        style: TextStyle(
                          //color: Color(0xFF111928),
                          fontSize: 14,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.id != null)
                        InkWell(
                          onTap: () async {
                            bool followed = await Provider.of<Profileprovider>(
                                    context,
                                    listen: false)
                                .followUser(
                                    Provider.of<AuthService>(context,
                                            listen: false)
                                        .currentUser!
                                        .id,
                                    widget.id!);

                            if (followed) {
                              setState(() {
                                Provider.of<Products>(context, listen: false)
                                    .getFollowersVisited(widget.id!);
                              });
                            }
                          },
                          child: Container(
                            width: 94,
                            height: 36,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: theme
                                  ? Color.fromARGB(255, 249, 217, 144)
                                  : Color(0xFFFB98B7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Consumer<Products>(
                                builder: (context, productsProvider, child) {
                                  bool isFollowing = productsProvider
                                      .followersvisited
                                      .any((follower) =>
                                          follower['id'] ==
                                          Provider.of<AuthService>(context,
                                                  listen: false)
                                              .currentUser!
                                              .id);

                                  return Text(
                                    isFollowing ? 'désabonner' : "S'abonner",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          theme ? Colors.black : Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  const Spacer(),
                  if (widget.id == null)
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Parametres()),
                          );
                        },
                        icon: SvgPicture.asset(
                          "assets/Icons/setting.svg",
                          color: theme ? Colors.white : null,
                        )),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Onglets
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab("Articles", index: 0, icon: "assets/Icons/item.svg"),
                _buildTab("Évaluations",
                    index: 1, icon: "assets/Icons/rating.svg"),
                _buildTab("À propos", index: 2, icon: "assets/Icons/about.svg"),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour les onglets
  Widget _buildTab(String title, {required int index, required String icon}) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index; // Mettre à jour l'onglet sélectionné
        });
      },
      child: Column(
        children: [
          SvgPicture.asset(
            icon,
            color: isSelected
                ? theme
                    ? Color.fromARGB(255, 249, 217, 144)
                    : Color(0xFFFB98B7)
                : theme
                    ? Colors.white
                    : Colors.black,
            height: 24,
            width: 24,
          ),

          const SizedBox(height: 4), // Espacement entre l'icône et le texte
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? theme
                      ? Color.fromARGB(255, 249, 217, 144)
                      : Color(0xFFFB98B7)
                  : theme
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 69,
              color: theme
                  ? Color.fromARGB(255, 249, 217, 144)
                  : Color(0xFFFB98B7),
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildItemsTab();
      case 1:
        return _buildRatingsTab();
      case 2:
        return _buildAboutTab();
      default:
        return const Center(child: Text("Invalid Tab"));
    }
  }

  Widget _buildItemsTab() {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Consumer<Products>(
      builder: (context, provider, child) {
        final products = widget.id == null
            ? provider.productsByUser
            : provider.productsByUserVisited;

        if (products.isEmpty) {
          return Center(
            child: Text(
              'Aucun produit disponible.',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final imageUrl = product['images']?.isNotEmpty == true
                ? "${AppConfig.baseUrl}/${product['images'][0]}"
                : 'assets/images/test1.png';

            return GestureDetector(
              onTap: widget.id == null
                  ? null
                  : () {
                      final productData = {
                        'type': 'Pour vous',
                        'category': product['category'] ?? 'Unknown',
                        'subcategory': product['subcategory'] ?? 'Unknown',
                        'imageUrl': imageUrl,
                        'images': product['images'] ?? [],
                        'productName': product['title'] ?? 'Unknown Product',
                        'productPrice': "${product['price']} TND",
                        'product_id': "${product['id']}",
                        'description': product['description'] ?? '',
                        'is_available': product['is_available'] ?? false,
                        'taille': product['taille'],
                        'is_favorite': product['is_favorite'] ?? false,
                        'pointure': product['pointure'],
                        'selled': product['selled'],
                        'brand': product['brand'],
                        'owner_id': widget.id,
                        'type_pdp': product['type'],
                        'owner_profile_pic':
                            product['owner']?['profile_pic'] ?? "",
                        'owner_username': product['owner']?['username'] ?? "",
                        'owner_ratings': product['owner']?['ratings'] ?? "",
                        'comments': (product['comments'] as List<dynamic>?)
                                ?.map((comment) => {
                                      'username':
                                          comment['username'] ?? 'Unknown',
                                      'avatar': comment['avatar'] ?? '',
                                      'content': comment['content'] ?? '',
                                      'created_at': comment['created_at'] ?? '',
                                    })
                                .toList() ??
                            [],
                      };

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemDetails(product: productData),
                        ),
                      );
                    },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ProductCard(
                        imageUrl: imageUrl,
                        productName: product['title'] ?? '',
                        productPrice: '${product['price']} TND',
                      ),
                      if (product['selled'] == true)
                        Positioned.fill(
                          child: Center(
                            child: Transform.rotate(
                              angle: -0.1,
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Vendu',
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.id == null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.all(16.0),
                                    height: 200, // Hauteur ajustée
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .updateProductSelled(
                                                    product['id'],
                                                    !(product['selled'] ??
                                                        false));
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .getProducts();
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .getProductsViewed();
                                            product['selled'] =
                                                !(product['selled'] ?? false);
                                          },
                                          child: Text(
                                            product['selled'] == true
                                                ? "Marquer comme disponible"
                                                : "Marquer comme vendu",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w700,
                                              height: 2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SellProductScreen(
                                                  product: product,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "Modifier l'article",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Raleway',
                                                  fontWeight: FontWeight.w700,
                                                  height: 2,
                                                ),
                                              ),
                                              const Spacer(),
                                              SvgPicture.asset(
                                                "assets/Icons/edit.svg",
                                                color: theme
                                                    ? Colors.white
                                                    : Colors.black,
                                                width: 30,
                                                height: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Confirmation',
                                                    style: TextStyle(
                                                      //color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Raleway',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.43,
                                                      letterSpacing: 0.10,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Êtes-vous sûr de vouloir supprimer cette article ? ',
                                                    style: TextStyle(
                                                      //color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Raleway',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.43,
                                                      letterSpacing: 0.10,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Ferme le dialog
                                                      },
                                                      child: Text(
                                                        'Annuler',
                                                        style: TextStyle(
                                                          //color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.43,
                                                          letterSpacing: 0.10,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                      bool deleted = await  Provider.of<Products>(
                                                                context,
                                                                listen: false)
                                                            .deleteProduct(
                                                                product["id"],
                                                                Provider.of<AuthService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .currentUser!
                                                                    .id);
                                                      if (deleted) {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                        
                                                      });
                                                      }
                                                      },
                                                      child: Container(
                                                        width: 110,
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 24,
                                                                vertical: 10),
                                                        decoration:
                                                            ShapeDecoration(
                                                          color:
                                                              Color(0xFFEA4335),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Supprimer',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Raleway',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.43,
                                                                letterSpacing:
                                                                    0.10,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Supprimer',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w700,
                                              height: 1.43,
                                              letterSpacing: 0.10,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (product['validated'] == false)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCF1D0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "En attente d'approbation",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRatingsTab() {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Consumer<Products>(
      builder: (context, ratingsProvider, child) {
        if ((widget.id == null && ratingsProvider.Ratings.isEmpty) ||
            (widget.id != null && ratingsProvider.RatingsVisited.isEmpty)) {
          return widget.id != null &&
                  Provider.of<Products>(context, listen: false).canRate == true
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Alignement horizontal à gauche
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = index +
                                  1; // Mise à jour de la note sélectionnée
                            });
                          },
                          child: Icon(
                            Icons.star,
                            color: index < selectedRating
                                ? Color(
                                    0xFFE4A709) // Couleur pour les étoiles sélectionnées
                                : Color(
                                    0xFFDDDDDD), // Couleur pour les étoiles non sélectionnées
                            size: 30,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: reviewController,
                      style: TextStyle(
                        //color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        height: 1.71,
                        letterSpacing: 0.50,
                      ),
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color(0xFF979797),
                          fontSize: 14,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          height: 1.71,
                          letterSpacing: 0.50,
                        ),
                        hintText: "Écrivez votre avis...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintStyle: TextStyle(
                          color: Color(0xFF979797),
                          fontSize: 14,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          height: 1.71,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        if (selectedRating > 0 &&
                            reviewController.text.isNotEmpty) {
                          // Appel à la fonction d'ajout de review
                          bool rated = await Provider.of<Profileprovider>(
                                  context,
                                  listen: false)
                              .addReview(
                            Provider.of<AuthService>(context, listen: false)
                                .currentUser!
                                .id,
                            widget.id!,
                            selectedRating,
                            reviewController.text,
                          );
                          if (rated) {
                            Provider.of<Products>(context, listen: false)
                                .getRatingByRatedUserVisited(
                              userId: widget.id!,
                            );
                            setState(() {});
                          }
                        }
                      },
                      child: Container(
                        width: 160,
                        height: 36,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: theme
                              ? Color.fromARGB(255, 249, 217, 144)
                              : Color(0xFFFB98B7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: theme ? Colors.black : Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Soumettre l'avis",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme ? Colors.black : Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/pana.svg"),
                      SizedBox(height: 16),
                      Text(
                        "Pas encore d'avis",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //color: Color(0xFF111928),
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.18,
                        ),
                      ),
                    ],
                  ),
                );
        } else {
          // Afficher les évaluations
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 136,
                  decoration: ShapeDecoration(
                    color: theme ? Colors.grey[900] : Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingPercentageRow(
                              stars: 5,
                              percentage: widget.id == null
                                  ? Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage5
                                  : Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage5Visited),
                          RatingPercentageRow(
                              stars: 4,
                              percentage: widget.id == null
                                  ? Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage4
                                  : Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage4Visited),
                          RatingPercentageRow(
                              stars: 3,
                              percentage: widget.id == null
                                  ? Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage3
                                  : Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage3Visited),
                          RatingPercentageRow(
                              stars: 2,
                              percentage: widget.id == null
                                  ? Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage2
                                  : Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage2Visited),
                          RatingPercentageRow(
                              stars: 1,
                              percentage: widget.id == null
                                  ? Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage1
                                  : Provider.of<Products>(context,
                                          listen: false)
                                      .ratingPercentage1Visited),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.id == null ? Provider.of<Products>(context, listen: false).avarageRate : Provider.of<Products>(context, listen: false).avarageRateVisited}',
                            style: TextStyle(
                              //color: Color(0xFF333333),
                              fontSize: 40,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.40,
                            ),
                          ),
                          StarRating(
                            rating: widget.id == null
                                ? Provider.of<Products>(context, listen: false)
                                    .avarageRate as double
                                : Provider.of<Products>(context, listen: false)
                                    .avarageRateVisited as double,
                          ),
                          Text(
                            '${widget.id == null ? Provider.of<Products>(context, listen: false).countRate : Provider.of<Products>(context, listen: false).countRateVisited} Reviews',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              //color: Color(0xFF333333),
                              fontSize: 14,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (widget.id != null) ...[
                  SizedBox(height: 16),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = index +
                                1; // Mise à jour de la note sélectionnée
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: index < selectedRating
                              ? Color(
                                  0xFFE4A709) // Couleur pour les étoiles sélectionnées
                              : Color(
                                  0xFFDDDDDD), // Couleur pour les étoiles non sélectionnées
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: reviewController,
                    style: TextStyle(
                      //color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      height: 1.71,
                      letterSpacing: 0.50,
                    ),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        //color: Color(0xFF979797),
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        height: 1.71,
                        letterSpacing: 0.50,
                      ),
                      hintText: "Écrivez votre avis...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintStyle: TextStyle(
                        color: Color(0xFF979797),
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        height: 1.71,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      if (selectedRating > 0 &&
                          reviewController.text.isNotEmpty &&
                          Provider.of<Products>(context, listen: false)
                                  .canRate ==
                              true) {
                        // Appel à la fonction d'ajout de review
                        bool rated = await Provider.of<Profileprovider>(context,
                                listen: false)
                            .addReview(
                          Provider.of<AuthService>(context, listen: false)
                              .currentUser!
                              .id,
                          widget.id!,
                          selectedRating,
                          reviewController.text,
                        );
                        if (rated) {
                          Provider.of<Products>(context, listen: false)
                              .getRatingByRatedUserVisited(
                            userId: widget.id!,
                          );
                          setState(() {});
                        }
                      } else {
                        setState(() {
                          errormsg = "vous ne pouvez pas ratez cet utilisateur";
                        });
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 36,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: theme
                            ? Color.fromARGB(255, 249, 217, 144)
                            : Color(0xFFFB98B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: theme ? Colors.black : Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Soumettre l'avis",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme ? Colors.black : Colors.white,
                                fontSize: 14,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  if (errormsg != null)
                    Text(
                      "$errormsg",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                ],
                ListView.builder(
                  shrinkWrap:
                      true, // Ajouté pour que la ListView ne prenne pas toute la hauteur disponible
                  physics:
                      NeverScrollableScrollPhysics(), // Désactive le scroll de la ListView, car le ScrollView parent s'en charge
                  itemCount: widget.id == null
                      ? ratingsProvider.Ratings.length
                      : ratingsProvider.RatingsVisited.length,
                  itemBuilder: (context, index) {
                    final rating = widget.id == null
                        ? ratingsProvider.Ratings[index]
                        : ratingsProvider.RatingsVisited[index];

                    int ratingValue = rating["rating"];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: (rating["avatar"] != "" &&
                                          rating["avatar"] != null)
                                      ? NetworkImage(rating["type"] == "normal"
                                          ? "${AppConfig.baseUrl}${rating["avatar"]}"
                                          : rating["avatar"]!)
                                      : AssetImage('assets/images/user.png')
                                          as ImageProvider,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rating["username"],
                                      style: TextStyle(
                                        //color: Color(0xFF333333),
                                        fontSize: 16,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        if (starIndex < ratingValue) {
                                          return Icon(
                                            Icons.star,
                                            color: Color(
                                                0xFFE4A709), // Couleur de l'étoile remplie
                                            size: 20,
                                          );
                                        } else {
                                          return Icon(
                                            Icons.star_border, // Étoile vide
                                            color: Color(0xFFDDDDDD),
                                            size: 20,
                                          );
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 13),
                            Text(
                              rating["content"],
                              style: TextStyle(
                                //color: Color(0xFF333333),
                                fontSize: 13,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                height: 1.38,
                                letterSpacing: -0.13,
                              ),
                            ),
                            SizedBox(height: 24),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 2,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFFD9D9D9)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // Contenu pour l'onglet "About"
  Widget _buildAboutTab() {
    return Align(
      alignment: Alignment.topLeft, // Aligner le contenu en haut à gauche
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
          ),
          Text(
            'Contacts',
            style: TextStyle(
              //color: Colors.black,
              fontSize: 14,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.14,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.id == null
                ? "${Provider.of<AuthService>(context, listen: false).currentUser?.address ?? ''}"
                : "${Provider.of<Profileprovider>(context, listen: false).visitedProfile?.address ?? ''}",
            style: TextStyle(
              //color: Colors.black,
              fontSize: 13,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
              height: 1.54,
              letterSpacing: -0.13,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.id == null
                ? "+216 ${Provider.of<AuthService>(context, listen: false).currentUser?.phoneNumber ?? ''}"
                : "+216 ${Provider.of<Profileprovider>(context, listen: false).visitedProfile?.phoneNumber ?? ''}",
            style: TextStyle(
              // color: Colors.black,
              fontSize: 13,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
              height: 1.54,
              letterSpacing: -0.13,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.id == null
                ? "${Provider.of<AuthService>(context, listen: false).currentUser?.email ?? ''}"
                : "${Provider.of<Profileprovider>(context, listen: false).visitedProfile?.email ?? ''}",
            style: TextStyle(
              //color: Colors.black,
              fontSize: 13,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
              height: 1.54,
              letterSpacing: -0.13,
            ),
          )
        ],
      ),
    );
  }
}
