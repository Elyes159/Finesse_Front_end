import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/HomeScreens/checkout.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:finesse_frontend/Screens/SellProduct/returnPolicyScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customfieldbuton.dart';
import 'package:finesse_frontend/Widgets/cards/detailcontainer.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ItemDetails extends StatefulWidget {
  final Map<String, dynamic> product;

  const ItemDetails({super.key, required this.product});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int _currentImageIndex = 0;
  bool isFavorite = false;
  bool isComented = false;
  String? parametre;
  Future<void> _loadParameter() async {
    parametre = await const FlutterSecureStorage().read(key: 'parametre');
  }

  String? errorMsg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadParameter();
    Provider.of<Profileprovider>(context, listen: false)
        .fetchProfile(widget.product["owner_id"]);
    Provider.of<Products>(context, listen: false)
        .getProductsByUserVisited(widget.product["owner_id"]);

    Provider.of<Products>(context, listen: false)
        .getProductsSelledByUserVisited(widget.product["owner_id"]);

    Provider.of<Products>(context, listen: false).getRatingByRatedUserVisited(
      userId: widget.product["owner_id"],
    );
    Provider.of<Products>(context, listen: false).checkOrderedorNot(
        first_id:
            Provider.of<AuthService>(context, listen: false).currentUser!.id,
        second_id: widget.product["owner_id"]);
    Provider.of<Products>(context, listen: false)
        .getFollowersVisited(widget.product["owner_id"]);
    Provider.of<Products>(context, listen: false)
        .getFollowingVisited(widget.product["owner_id"]);
    isFavorite = widget.product["is_favorite"] ?? false;
  }

  void toggleFavorite() {
  setState(() {
    isFavorite = !isFavorite!;
  });

  final productsProvider = Provider.of<Products>(context, listen: false);
  final userId = Provider.of<AuthService>(context, listen: false).currentUser!.id;

  if (isFavorite == true) {
    productsProvider.createWish(productId: widget.product["product_id"]);
    productsProvider.getWish(userId);
  } else {
    productsProvider.deleteWish(widget.product["id_wish"]);
    productsProvider.getWish(userId);
  }
}


  bool containsPhoneOrEmail(String text) {
    // Expression régulière pour détecter une adresse email
    final RegExp emailRegex = RegExp(
      r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}",
    );

    // Expression régulière pour détecter un numéro de téléphone
    final RegExp phoneRegex = RegExp(
      r"(?:\+?\d{1,3}[ -]?)?(?:\(?\d{2,4}\)?[ -]?)?\d{3,4}[ -]?\d{3,4}",
    );

    return emailRegex.hasMatch(text) || phoneRegex.hasMatch(text);
  }

  final TextEditingController _commentController = TextEditingController();
  String getTimeAgo(String createdDate) {
    // Convertir la chaîne de date en DateTime
    DateTime createdDateTime = DateTime.parse(createdDate);

    // Obtenir la date et l'heure actuelles
    DateTime now = DateTime.now();

    // Calculer la différence entre la date actuelle et la date de création
    Duration difference = now.difference(createdDateTime);

    if (difference.inDays > 365) {
      // Si plus d'un an, afficher en années
      int years = difference.inDays ~/ 365;
      return "il y a $years ${years > 1 ? 'ans' : 'an'}";
    } else if (difference.inDays > 30) {
      // Si plus d'un mois, afficher en mois
      int months = difference.inDays ~/ 30;
      return "il y a $months ${months > 1 ? 'mois' : 'mois'}";
    } else if (difference.inDays > 0) {
      // Si plus d'un jour
      return "il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}";
    } else if (difference.inHours > 0) {
      // Si plus d'une heure
      return "il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}";
    } else if (difference.inMinutes > 0) {
      // Si plus d'une minute
      return "il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}";
    } else {
      // Si moins d'une minute
      return "il y a quelques secondes";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final now = DateTime.now();

    // Fonction pour obtenir la date au format "lundi 31 mars"
    String formatDate(DateTime date) {
      final months = [
        "janvier",
        "février",
        "mars",
        "avril",
        "mai",
        "juin",
        "juillet",
        "août",
        "septembre",
        "octobre",
        "novembre",
        "décembre"
      ];

      final dayOfWeek = date.weekday;
      String weekday = "";

      switch (dayOfWeek) {
        case 1:
          weekday = "lundi";
          break;
        case 2:
          weekday = "mardi";
          break;
        case 3:
          weekday = "mercredi";
          break;
        case 4:
          weekday = "jeudi";
          break;
        case 5:
          weekday = "vendredi";
          break;
        case 6:
          weekday = "samedi";
          break;
        case 7:
          weekday = "dimanche";
          break;
      }

      return "$weekday ${date.day} ${months[date.month - 1]}";
    }

    // Fonction pour obtenir le lundi suivant si c'est le week-end, sinon la date du jour
    DateTime getNextWeekday(DateTime startDate) {
      if (startDate.weekday == 6 || startDate.weekday == 7) {
        // Si c'est samedi ou dimanche, retourne lundi
        return startDate.add(Duration(
            days: (8 -
                startDate
                    .weekday))); // 8 - 6 = 2 jours pour samedi, 8 - 7 = 1 jour pour dimanche
      }
      return startDate.add(Duration(days: 1)); // Sinon retourne demain
    }

    // Date de demain
    DateTime tomorrow = getNextWeekday(now);
    // Date après-demain
    DateTime afterTomorrow = getNextWeekday(tomorrow);

    final filteredProducts = Provider.of<Products>(context, listen: false)
        .products
        .where((productItem) =>
            productItem["subcategory"] == widget.product["subcategory"] &&
            productItem["id"] != widget.product["product_id"])
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Détails de l'article",
          style: TextStyle(
            //color: Colors.black,
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.50,
          ),
        ),
      ),
      body: Column(
        children: [
          // SingleChildScrollView avec un padding en bas pour éviter que le contenu ne soit caché par le champ de texte
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom:
                      80), // Ajoutez un padding en bas pour le champ de texte
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Carousel with rounded corners and partial next image
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, right: 1, left: 16, bottom: 8),
                    child: SizedBox(
                      height: 257,
                      child: PageView.builder(
                        itemCount: widget.product['images'].length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 20), // Slight padding to show next image
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                              child: Image.network(
                                "${AppConfig.baseUrl}/${widget.product['images'][index]}",
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Image indicator (below the carousel)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.product['images'].length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Color(0xFFC668AA)
                                : Color(0xFFD9D9D9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Product Details
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 18),
                        Row(
                          children: [
                            Text(
                              widget.product['productName'],
                              style: TextStyle(
                                //color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                print(widget.product["created"]);
                              },
                              child: Text(
                                "${widget.product["productPrice"]} TND",
                                style: TextStyle(
                                  //color: Color(0xFF111928),
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing:
                              10, // Espacement horizontal entre les éléments
                          runSpacing:
                              10, // Espacement vertical entre les lignes
                          children: [
                            if (widget.product["brand"] != "('',)") ...[
                              DetailsContainer(
                                content: widget.product["brand"],
                                title: 'Marque',
                              ),
                            ],
                            if (widget.product["taille"] != "XX") ...[
                              DetailsContainer(
                                title: "Taille",
                                content: widget.product["taille"],
                              ),
                            ],
                            if (widget.product["pointure"] != "XX") ...[
                              DetailsContainer(
                                title: "Taille",
                                content: widget.product["pointure"],
                              ),
                            ],
                            if (widget.product["longeur"] != "XX" &&
                                widget.product["longeur"] != "('',)"&& widget.product["longeur"]!=null) ...[
                              DetailsContainer(
                                title: "Longueur",
                                content: widget.product["longeur"] + " cm",
                              ),
                            ],
                            if (widget.product["largeur"] != "XX" &&
                                widget.product["largeur"] != "('',)" && widget.product["largeur"]!=null) ...[
                              DetailsContainer(
                                title: "Largeur",
                                content: widget.product["largeur"] + " cm",
                              ),
                            ],
                            if (widget.product["hauteur"] != "XX" &&
                                widget.product["hauteur"] != "('',)"&& widget.product["hauteur"]!=null) ...[
                              DetailsContainer(
                                title: "Hauteur",
                                content: widget.product["hauteur"] + " cm",
                              ),
                            ],
                            if (widget.product["etat"] != null &&
                                widget.product["etat"] != "('',)") ...[
                              DetailsContainer(
                                content: widget.product["etat"],
                                title: 'État',
                              ),
                            ],
                            if (widget.product["color"] != null &&
                                widget.product["color"] != "XX") ...[
                              DetailsContainer(
                                content: widget.product["color"],
                                title: 'Couleur',
                              ),
                            ],
                            DetailsContainer(
                              content: getTimeAgo(widget.product["created"]),
                              title: 'Déposé',
                            ),
                          ],
                        ),
                        SizedBox(height: 26),
                        InkWell(
                          onTap: () {
                            Provider.of<Profileprovider>(context, listen: false)
                                .fetchProfile(widget.product["owner_id"]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileMain(
                                          id: widget.product["owner_id"],
                                        )));
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: (widget.product[
                                                  "owner_profile_pic"] !=
                                              "" &&
                                          widget.product["owner_profile_pic"] !=
                                              null)
                                      ? NetworkImage(widget
                                                      .product["type_pdp"] ==
                                                  "google" ||
                                              widget.product["type_pdp"] ==
                                                  "facebook"
                                          ? "${widget.product["owner_profile_pic"]}"
                                          : "${AppConfig.baseUrl}/${widget.product["owner_profile_pic"]}")
                                      : AssetImage('assets/images/user.png')
                                          as ImageProvider,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Aligns the text to the left
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.product["owner_username"]}",
                                    style: TextStyle(
                                      //color: Color(0xFF111928),
                                      fontSize: 16,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w500,
                                      height: 1.50,
                                      letterSpacing: 0.15,
                                    ),
                                  ),
                                  Text(
                                    '⭐️ ${widget.product["owner_ratings"]?.toStringAsFixed(2) ?? "0.00"}',
                                    style: TextStyle(
                                      //color: Color(0xFF111928),
                                      fontSize: 14,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w500,
                                      height: 1.43,
                                      letterSpacing: 0.10,
                                    ),
                                    textAlign: TextAlign
                                        .start, // Assure que le texte est aligné à gauche
                                  )
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    Provider.of<Profileprovider>(context,
                                            listen: false)
                                        .fetchProfile(
                                            widget.product["owner_id"]);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfileMain(
                                                  id: widget
                                                      .product["owner_id"],
                                                )));
                                  },
                                  child: SvgPicture.asset(
                                    "assets/Icons/arrow_profile.svg",
                                    color: theme
                                        ? Color.fromARGB(255, 249, 217, 144)
                                        : null,
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  //
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alignement en haut
                    children: [
                      Expanded(
                        // Permet à la description de prendre plusieurs lignes
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Text(
                            '${widget.product["description"]}',
                            style: TextStyle(
                              //color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              height: 1.38,
                              letterSpacing: -0.13,
                            ),
                          ),
                        ),
                      ),

                      // Trouver le produit dans wishProducts

                     InkWell(
      onTap: toggleFavorite,
      child: Icon(
        Icons.favorite,
        color: isFavorite == true ? Colors.red : Colors.grey,
      ),
    ),

                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            "Livraison",
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
                            "L’article est disponible. Commandez dès maintenant et recevez-le sous 48h.\n"
                            "Pour suivre l’état actuel de votre commande, consultez l’onglet <Commande> après la finalisation de votre achat.",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: theme
                                  ? Color.fromARGB(255, 249, 217, 144)
                                  : Colors.black,
                              height: 1.5, // Espacement entre les lignes
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReturnPolicyScreen()));
                      },
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Largeur égale à celle de l'écran
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              "Protection",
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
                              "Retour Gratuit sous Conditions.\nCliquez ici pour en savoir plus",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: theme
                                    ? Color.fromARGB(255, 249, 217, 144)
                                    : Colors.black,
                                height: 1.5, // Espacement entre les lignes
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Commentaires",
                      style: TextStyle(
                        color: theme
                            ? Color.fromARGB(255, 249, 217, 144)
                            : Colors.black,
                        //color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        height: 1.38,
                        letterSpacing: -0.13,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CustomTextFormFieldwithButton(
                      isCommented: isComented,
                      controller: _commentController,
                      label: 'Votre commentaire',
                      isPassword: false,
                      onButtonPressed: () async {
                        String commentText = _commentController.text.trim();

                        if (commentText.isEmpty) {
                          setState(() {
                            errorMsg = "Le commentaire est vide";
                          });
                          return;
                        }

                        if (containsPhoneOrEmail(commentText)) {
                          setState(() {
                            errorMsg =
                                "Votre commentaire ne doit pas contenir de numéro ou d'email.";
                          });
                          return;
                        }

                        bool? commented =
                            await Provider.of<Products>(context, listen: false)
                                .createComment(
                                    productId: widget.product["product_id"],
                                    content: commentText);

                        if (commented) {
                          setState(() {
                            errorMsg = null;
                            isComented = true;
                          });

                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              isComented = false;
                            });
                          });

                          Provider.of<Products>(context, listen: false)
                              .getProducts();
                          Provider.of<Products>(context, listen: false)
                              .getProductsViewed();
                        } else {
                          setState(() {
                            errorMsg = "Erreur survenue";
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            "Attention !",
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
                            "Pour votre sécurité, ne communiquez jamais vos informatiosn personnelles (Facebook, numéro de téléphone, e-mail, adresse) dans les commentaires. En cliquant sur Acheter, vous êtes protégé contre les arnaques et les mauvaises surprises.",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: theme
                                  ? Color.fromARGB(255, 249, 217, 144)
                                  : Colors.black,
                              height: 1.5, // Espacement entre les lignes
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (errorMsg != null)
                    Text(
                      "$errorMsg",
                      style: TextStyle(
                        fontFamily: "Raleway",
                        color: Colors.red,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                  widget.product['comments'].isNotEmpty
                      ? Column(
                          children: widget.product['comments']
                              .map<Widget>((comment) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: (comment['avatar'] !=
                                                      "" &&
                                                  comment['avatar'] != null)
                                              ? NetworkImage(
                                                  "${AppConfig.baseUrl}${comment['avatar']}")
                                              : AssetImage(
                                                      'assets/images/user.png')
                                                  as ImageProvider,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment['username'] ??
                                                    "Utilisateur inconnu",
                                                style: TextStyle(
                                                  //color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: "Raleway",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                comment['content'] ??
                                                    "Commentaire vide",
                                                style: TextStyle(
                                                  //color: Colors.black87,
                                                  fontSize: 13,
                                                  fontFamily: "Raleway",
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                getTimeAgo(
                                                    comment['created_at']),
                                                style: TextStyle(
                                                  //color: Colors.grey,
                                                  fontSize: 12,
                                                  fontFamily: "Raleway",
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        )
                      : SizedBox(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Articles similaires",
                      style: TextStyle(
                        color: theme
                            ? Color.fromARGB(255, 249, 217, 144)
                            : Colors.black,
                        //color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        height: 1.38,
                        letterSpacing: -0.13,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height:
                          400, // Définir une hauteur fixe pour votre GridView
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 colonnes
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio:
                              0.7, // Ajuster pour la taille des cartes
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              {
                                final productData = {
                                  'type': "Récemment consulté",
                                  'subcategory':
                                      product['subcategory'] ?? 'Unknown',
                                  'imageUrl':
                                      "${AppConfig.baseUrl}${product['images'][0]}"
                                              .isNotEmpty
                                          ? "${AppConfig.baseUrl}${product['images'][0]}"
                                          : 'assets/images/test1.png',
                                  'images': product['images'] ??
                                      [], // Liste complète des images
                                  'productName':
                                      product['title'] ?? 'Unknown Product',
                                  'productPrice':
                                      "${product['price']}".toString(),
                                  'product_id': "${product['id']}",
                                  'description': product['description'] ?? '',
                                  'is_available':
                                      product['is_available'] ?? false,
                                  'category': product['category'] ?? 'Unknown',
                                  'taille': product['taille'],
                                  'pointure': product['pointure'],
                                  'brand': product['brand'],
                                  "longeur": product["longeur"],
                                  "hauteur": product["hauteur"],
                                  'etat': product["etat"],
                                  "largeur": product["largeur"],
                                  'selled': product["selled"],
                                  "created": product["created"],
                                  'type_pdp': product["type"],
                                  'owner_id': product["owner"]["id"],
                                  'is_favorite': product['is_favorite'],
                                  'owner_profile_pic':
                                      product["owner"]["profile_pic"] ?? "",
                                  'owner_username':
                                      product["owner"]["username"] ?? "",
                                  'owner_ratings':
                                      product["owner"]["ratings"] ?? "",
                                  'comments': product['comments']
                                          ?.map((comment) => {
                                                'username':
                                                    comment['username'] ??
                                                        'Unknown',
                                                'avatar':
                                                    comment['avatar'] ?? '',
                                                'content':
                                                    comment['content'] ?? '',
                                                'created_at':
                                                    comment['created_at'] ?? '',
                                              })
                                          .toList() ??
                                      [], // Ajout des commentaires ici
                                };

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ItemDetails(product: productData),
                                  ),
                                );
                              }
                            },
                            child: ProductCard(
                              imageUrl:
                                  "${AppConfig.baseUrl}${product["images"][0]}",
                              productName: product["title"],
                              productPrice: product["price"],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
                right: 16.0,
                left: 16,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomButton(
                  label: "Acheter",
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                                productIds: [widget.product["product_id"]],
                                subtotal: double.tryParse(
                                        widget.product["productPrice"]) ??
                                    99.0,
                                total: double.tryParse(
                                        widget.product["productPrice"])! +
                                    7)));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
