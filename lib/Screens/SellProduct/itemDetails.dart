import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customfieldbuton.dart';
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
    Provider.of<Products>(context, listen: false).getRatingByRatedUserVisited(
      userId: widget.product["owner_id"],
    );
    Provider.of<Products>(context, listen: false)
        .getFollowersVisited(widget.product["owner_id"]);
    isFavorite = widget.product["is_favorite"] ?? false;
  }

  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Item Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.50,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/ArrowLeft.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // SingleChildScrollView avec un padding en bas pour éviter que le contenu ne soit caché par le champ de texte
          SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: 80), // Ajoutez un padding en bas pour le champ de texte
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
                      Text(
                        widget.product['productName'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Brand: ${widget.product["brand"]}",
                            style: TextStyle(
                              color: Color(0xFF111928),
                              fontSize: 16,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                          Text(
                            widget.product["taille"] != "U"
                                ? "Size: ${widget.product["taille"]}"
                                : widget.product["pointure"] != "99"
                                    ? "Size: ${widget.product["taille"]}"
                                    : "",
                            style: TextStyle(
                              color: Color(0xFF111928),
                              fontSize: 16,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                          Text(
                            "${widget.product["productPrice"]}",
                            style: TextStyle(
                              color: Color(0xFF111928),
                              fontSize: 16,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
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
                                backgroundImage: (widget
                                                .product["owner_profile_pic"] !=
                                            "" &&
                                        widget.product["owner_profile_pic"] !=
                                            null)
                                    ? NetworkImage(parametre == "normal"
                                        ? "${AppConfig.baseUrl}/${widget.product["owner_profile_pic"]}"
                                        : "${AppConfig.baseUrl}/${widget.product["owner_profile_pic"]}")
                                    : AssetImage('assets/images/user.png')
                                        as ImageProvider,
                                backgroundColor: Colors.transparent,
                                child: widget.product[""] == null
                                    ? Container()
                                    : null,
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
                                    color: Color(0xFF111928),
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
                                    color: Color(0xFF111928),
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
                                      .fetchProfile(widget.product["owner_id"]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileMain(
                                                id: widget.product["owner_id"],
                                              )));
                                },
                                child: SvgPicture.asset(
                                    "assets/Icons/arrow_profile.svg"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Text(
                    '${widget.product["description"]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: -0.13,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Commentaires",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: -0.13,
                    ),
                  ),
                ),
                SizedBox(height: 8),
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
                                                color: Colors.black,
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
                                                color: Colors.black87,
                                                fontSize: 13,
                                                fontFamily: "Raleway",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              comment['created_at'] ??
                                                  "Date inconnue",
                                              style: TextStyle(
                                                color: Colors.grey,
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
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 90, left: 16),
                        child: Text(
                          "Aucun commentaire pour le moment.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          // Position the CustomTextFormFieldwithButton at the bottom of the screen
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CustomTextFormFieldwithButton(
                    isCommented: isComented,
                    controller: _commentController,
                    label: 'Your comment',
                    isPassword: false,
                    onButtonPressed: () async {
                      if (_commentController.text.isEmpty) {
                        setState(() {
                          errorMsg = "commentaire est vide";
                        });
                      } else {
                        bool? commented =
                            await Provider.of<Products>(context, listen: false)
                                .createComment(
                                    productId: widget.product["product_id"],
                                    content: _commentController.text);
                        if (commented) {
                          setState(() {
                            errorMsg = null;
                            isComented = true;
                            Provider.of<Products>(context, listen: false)
                                .getProducts();
                            Provider.of<Products>(context, listen: false)
                                .getProductsViewed();
                          });
                        } else {
                          setState(() {
                            errorMsg = "something wrong";
                          });
                        }
                      }
                    },
                  ),
                ),
                if (errorMsg != null)
                  Text(
                    "$errorMsg",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: CustomButton(
                      buttonColor: isFavorite ? Colors.grey : Color(0xFFFB98B7),
                      label: !isFavorite ? "Add to cart" : "Add to cart ✅ " ,
                      onTap: () async {
                              bool? favorite = await Provider.of<Products>(
                                      context,
                                      listen: false)
                                  .createFavorite(
                                      productId: widget.product["product_id"]);

                              if (favorite != false) {
                                setState(() {
                                  Provider.of<Products>(context, listen: false)
                                      .getFavourite(Provider.of<AuthService>(
                                              context,
                                              listen: false)
                                          .currentUser!
                                          .id);
                                  isFavorite =
                                      favorite; // Met à jour l'état local
                                });
                              }
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
