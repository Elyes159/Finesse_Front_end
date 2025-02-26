import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/HomeScreens/checkout.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    
    final theme = Provider.of<ThemeProvider>(context,listen:false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Panier",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.50,
          ),
        ),
      ),
      body: Consumer<Products>(
        builder: (context, products, child) {
          List<dynamic> favorites = products.favoriteProducts;

          // Calculer le sous-total
          double subtotal = 0.0;
          for (var product in favorites) {
            subtotal += product['price'];
          }
          const double deliveryFee = 7.0;
          double total = subtotal + deliveryFee;

          return SingleChildScrollView(
            
            child: favorites.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 300,),
                        Text(
                          'Panier vide',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
                            height: 1.38,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 48,
                          child: SizedBox(
                            width: 251,
                            height: 48,
                            child: Text(
                              "Ajoutez des articles à votre panier",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Liste des produits
                        ListView.builder(
                          shrinkWrap:
                              true, // Permet à la liste de prendre seulement l'espace nécessaire
                          physics:
                              const NeverScrollableScrollPhysics(), // Empêche le défilement de la liste
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final product = favorites[index];
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product['images'].isNotEmpty
                                              ? "${AppConfig.baseUrl}/${product['images'][0]}"
                                              : 'assets/placeholder.png',
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['title'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w400,
                                                height: 1.50,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              product['description'] ??
                                                  'Aucune description',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w400,
                                                height: 1.50,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${product['price']} DT',
                                            style: TextStyle(
                                              
                                              fontSize: 16,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w500,
                                              height: 1,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          TextButton(
                                            onPressed: () {
                                              Provider.of<Products>(context,
                                                      listen: false)
                                                  .deleteFavorite(
                                                      product['id_fav']);
                                            },
                                            child: const Text(
                                              'Supprimer',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w500,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(thickness: 1, color: Colors.grey),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        // Ajouter les lignes de total ici
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sous-total:',
                              style: TextStyle(
                                
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                                letterSpacing: 0.15,
                              ),
                            ),
                            Text(
                              '${subtotal.toStringAsFixed(2)} DT',
                              style: TextStyle(
                                
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                                letterSpacing: 0.15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Livraison:',
                              style: TextStyle(
                                //color: Color(0xFF111928),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                                letterSpacing: 0.15,
                              ),
                            ),
                            const Text(
                              '7.00 DT',
                              style: TextStyle(
                                //color: Color(0xFF111928),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                                letterSpacing: 0.15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total des achats:',
                              style: TextStyle(
                                 //color: Color(0xFF111928),
                                fontSize: 22,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                                height: 1.27,
                              ),
                            ),
                            Text(
                              '${total.toStringAsFixed(2)} DT',
                              style: TextStyle(
                                //color: Color(0xFF111928),
                                fontSize: 22,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                                height: 1.27,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        CustomButton(
                          buttonColor: Color(0xFFC668AA),
                          label: "Passer à la caisse",
                          onTap: () {
                            List<dynamic> productIds = favorites
                                .map((product) => product['id'])
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  productIds: productIds,
                                  subtotal: subtotal,
                                  total: total,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
