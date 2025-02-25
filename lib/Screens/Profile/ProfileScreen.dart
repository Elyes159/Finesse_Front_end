import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:finesse_frontend/Screens/Profile/Settings.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
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
  TextEditingController reviewController =
      TextEditingController(); // Onglet actuellement sélectionné

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
                          color: Color(0xFF111928),
                          fontSize: 20,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.id == null
                            ? '${Provider.of<Products>(context, listen: false).nbfollowers} followers'
                            : '${Provider.of<Products>(context, listen: false).nbfollowervisited} followers',
                        style: TextStyle(
                          color: Color(0xFF111928),
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
                              color: Color(0xFFFB98B7),
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
                                    isFollowing ? 'Unfollow' : 'Follow',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
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
                            MaterialPageRoute(builder: (context) => Settings()),
                          );
                        },
                        icon: SvgPicture.asset("assets/Icons/setting.svg")),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Onglets
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab("Items", index: 0, icon: "assets/Icons/item.svg"),
                _buildTab("Ratings", index: 1, icon: "assets/Icons/rating.svg"),
                _buildTab("About", index: 2, icon: "assets/Icons/about.svg"),
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
            color: isSelected ? Color(0xFFFB98B7) : Colors.black,
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
              color: isSelected ? Color(0xFFFB98B7) : Colors.black,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 69,
              color: Color(0xFFFB98B7),
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
    return Consumer<Products>(
      builder: (context, provider, child) {
        final products = widget.id == null
            ? provider.productsByUser
            : provider.productsByUserVisited;

        if (products.isEmpty) {
          return Center(
            child: Text('Aucun produit disponible.'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(
              vertical: 16.0), // Ajoute un padding au contenu
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux colonnes
            crossAxisSpacing: 16.0, // Espacement horizontal
            mainAxisSpacing: 16.0, // Espacement vertical
            childAspectRatio: 3 / 4, // Proportion des items
          ),
          itemCount: products.length, // Nombre total de produits
          itemBuilder: (context, index) {
            final product = products[index]; // Récupérer un produit de la liste
            final imageUrl = product['images'] != null &&
                    product['images'].isNotEmpty
                ? "${AppConfig.baseUrl}/${product['images'][0]}" // Première image
                : 'assets/images/default.png'; // Image par défaut si aucune image

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ProductCard(
                      imageUrl: imageUrl,
                      productName: product['title'] as String,
                      productPrice: '${product['price']} TND',
                    ),
                    // Badge "Vendu"
                    if (product["selled"] ==
                        true) // Vérifie si le produit est vendu
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          // Centre le badge dans le conteneur parent
                          child: Transform.rotate(
                            angle: -0.1, // Angle pour incliner le badge
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(
                                    0.7), // Couleur rouge avec opacité
                                borderRadius:
                                    BorderRadius.circular(10), // Coins arrondis
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
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          // Afficher le BottomSheet lorsque l'utilisateur clique sur la flèche
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomButton(
                                      label: product["selled"] == true
                                          ? "Marquer comme disponible"
                                          : "Marquer comme vendu",
                                      onTap: () {
                                        Provider.of<Products>(context,
                                                listen: false)
                                            .updateProductSelled(
                                                product["id"],
                                                product["selled"] == true
                                                    ? false
                                                    : true);
                                        Provider.of<Products>(context,
                                                listen: false)
                                            .getProducts();
                                        Provider.of<Products>(context,
                                                listen: false)
                                            .getProductsViewed();
                                        product["selled"] = !product["selled"];
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    // Ajoute ici d'autres widgets pour afficher les détails
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                if (product["validated"] == false) ...[
                  SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: ShapeDecoration(
                      color: Color(0xFFFCF1D0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pending approval',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              ],
            );
          },
        );
      },
    );
  }

  // Contenu pour l'onglet "Ratings"
  Widget _buildRatingsTab() {
    return Consumer<Products>(
      builder: (context, ratingsProvider, child) {
        if ((widget.id == null && ratingsProvider.Ratings.isEmpty) ||
            (widget.id != null && ratingsProvider.RatingsVisited.isEmpty)) {
          return widget.id != null && Provider.of<Products>(context,listen: false).canRate == true
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
                        color: Colors.black,
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
                        hintText: "Write your review...",
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
                          color: Color(0xFFFB98B7),
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
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Submit review',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
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
                        'No reviews yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF111928),
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
                    color: Color(0xFFF7F7F7),
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
                              color: Color(0xFF333333),
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
                              color: Color(0xFF333333),
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
                      color: Colors.black,
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
                      hintText: "Write your review...",
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
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 36,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFB98B7),
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
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Submit review',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
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
                                      ? NetworkImage(parametre == "normal"
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
                                        color: Color(0xFF333333),
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
                                color: Color(0xFF333333),
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
              color: Colors.black,
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
              color: Colors.black,
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
              color: Colors.black,
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
              color: Colors.black,
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

  // Carte d'un item
  Widget _buildItemCard({
    required String imageUrl,
    required String title,
    required String price,
    int? notifications,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  price,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        if (notifications != null)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$notifications',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
