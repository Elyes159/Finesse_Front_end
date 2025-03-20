import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Products>(context, listen: false).getWish(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Text(
              'Favoris',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                height: 1.25,
                letterSpacing: 0.50,
              ),
            ),
          ),
        ),
      ),
      body: Consumer<Products>(
        builder: (context, productsProvider, child) {
          final wishProducts = productsProvider.wishProducts;

          if (wishProducts.isEmpty) {
            return const Center(
              child: Text(
                "Aucun produit favori",
                 style: TextStyle(
                            //color: Color(0xFF111928),
                            fontSize: 32,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
                            height: 1.38,
                          ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: wishProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Deux colonnes
                crossAxisSpacing: 10, // Espacement horizontal
                mainAxisSpacing: 10, // Espacement vertical
                childAspectRatio: 0.75, // Ratio ajusté pour la carte produit
              ),
              itemBuilder: (context, index) {
                final product = wishProducts[index];
                final wishId = product["wish"]; // ID pour suppression

                return Stack(
                  children: [
                    ProductCard(
                      imageUrl:
                          "${AppConfig.baseUrl}${product["images"][0]}", // Assure-toi que la clé est correcte
                      productName: product["title"] ?? "Produit",
                      productPrice: "${product["price"] ?? '0'} TND",
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: InkWell(
                        onTap: () {
                          
                            productsProvider.deleteWish(product["id_wish"]);
                            productsProvider.getWish(
                                Provider.of<AuthService>(context, listen: false)
                                    .currentUser!
                                    .id);
                        
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset("assets/Icons/heart-remove.svg")
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
