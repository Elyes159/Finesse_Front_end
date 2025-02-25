import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/boostArticle.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finesse_frontend/Provider/products.dart'; // Assurez-vous que le chemin est correct

class Boost extends StatefulWidget {
  const Boost({super.key});
  @override
  State<Boost> createState() => _BoostState();
}

class _BoostState extends State<Boost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Text(
              'Boost',
              style: TextStyle(
                color: Color(0xFF111928),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<Products>(
          builder: (context, productsProvider, child) {
            final products = productsProvider.productsByUser;

            if (products.isEmpty) {
              return const Center(
                child: Text(
                  "Aucun produit disponible",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }

            return GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Nombre de colonnes
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7, // Ajuster la hauteur des cartes
              ),
              itemBuilder: (context, index) {
                final product = products[index];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductCard(
                      imageUrl:
                          "${AppConfig.baseUrl}${product["images"][0]}", // Assurez-vous que la clé est correcte
                      productName: product[
                          "title"], // Assurez-vous que la clé est correcte
                      productPrice: product[
                          "price"], // Assurez-vous que la clé est correcte
                    ),
                    if (product["is_boosted"] == false)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoostArticle(
                                id : product["id"],
                                imageUrls:
                                    product["images"],
                                title: product["title"],
                                price: product["price"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 95,
                          height: 28,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: ShapeDecoration(
                            color: Color(0xFFFB98B7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Boost Article',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w400,
                                  height: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 95,
                        height: 28,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: ShapeDecoration(
                          color: Color(0xFFC9E7D1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Boost Active',
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
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
