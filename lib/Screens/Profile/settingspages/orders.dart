import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/SellProduct/suiviCommande.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int _selectedIndex = 0; // État pour savoir quel bouton est sélectionné

  // Fonction appelée lors de la sélection d'un bouton
  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index; // Met à jour l'index sélectionné
    });
  }

  String _formatDate(String isoDate) {
    DateTime date = DateTime.parse(isoDate); // Convertit la chaîne en DateTime
    return "${date.day}/${date.month}/${date.year}"; // Format "dd/MM/yyyy"
  }

  // Widget pour afficher le contenu A
  Widget _buildContentA(List orderData) {
    return ListView.builder(
      itemCount: orderData.length,
      itemBuilder: (context, index) {
        final order = orderData[index];
        final product = order['product']; // Accédez aux détails du produit

        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderTrackingPage(order: order,)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), // Bords arrondis
                      child: Image.network(
                        product['images'].isNotEmpty
                            ? "${AppConfig.baseUrl}${product['images'][0]}"
                            : 'assets/images/placeholder.png', // Image par défaut
                        width: 80, // Largeur réduite de l’image
                        height: 80,
                        fit: BoxFit.cover, // Ajustement de l’image
                      ),
                    ),
                    const SizedBox(
                        width: 16), // Espacement entre l’image et le texte
          
                    // Détails du produit
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${product['title']} (Ref${order["order_id"]})",
                            style: TextStyle(
                              //color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              height: 1.54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow
                                .ellipsis, // Coupe le texte s'il est trop long
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(order[
                                'created_at']), // Utilisation de la fonction de formatage
                            style: TextStyle(
                              //color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              height: 1.54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow
                                .ellipsis, // Coupe le texte s'il est trop long
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${product['price']} TND", // Affichage du prix
                            style: TextStyle(
                              //color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              height: 1.67,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product["owner"]}',
                      style: TextStyle(
                        //color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        height: 1.54,
                      ),
                    ),
                    Text(
                      '${order["total_price"]}',
                      style: TextStyle(
                        //color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        height: 1.54,
                      ),
                    ),
                    Text(
                      order["status"] == "paye"
                          ? 'payé'
                          : order["status"] == "livraison"
                              ? "paiement à la livraison"
                              : "non défini",
                      style: TextStyle(
                        color: Color(0xFFC668AA),
                        fontSize: 13,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        height: 1.54,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 1, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget pour afficher le contenu B
  Widget _buildContentB(List orderData) {
    return ListView.builder(
      itemCount: orderData.length,
      itemBuilder: (context, index) {
        final order = orderData[index];
        final product = order['product']; // Accédez aux détails du produit

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image du produit (petite taille)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // Bords arrondis
                    child: Image.network(
                      product['images'].isNotEmpty
                          ? "${AppConfig.baseUrl}${product['images'][0]}"
                          : 'assets/images/placeholder.png', // Image par défaut
                      width: 80, // Largeur réduite de l’image
                      height: 80,
                      fit: BoxFit.cover, // Ajustement de l’image
                    ),
                  ),
                  const SizedBox(
                      width: 16), // Espacement entre l’image et le texte

                  // Détails du produit
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${product['title']} (Ref${order["order_id"]})",
                          style: TextStyle(
                            //color: Colors.black,
                            fontSize: 13,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            height: 1.54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis, // Coupe le texte s'il est trop long
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(order[
                              'created_at']), // Utilisation de la fonction de formatage
                          style: TextStyle(
                            //color: Colors.black,
                            fontSize: 13,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            height: 1.54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis, // Coupe le texte s'il est trop long
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${product['price']} TND", // Affichage du prix
                          style: TextStyle(
                            //color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            height: 1.67,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order["full_name"]}',
                    style: TextStyle(
                      //color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      height: 1.54,
                    ),
                  ),
                  Text(
                    '${order["phone_buyer"]}',
                    style: TextStyle(
                      //color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      height: 1.54,
                    ),
                  ),
                  Text(
                    '${order["total_price"]}',
                    style: TextStyle(
                      // color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      height: 1.54,
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Consumer<AuthService>(
      builder: (context, provider, child) {
        final orderData =
            provider.orderdata; // Accédez à votre liste de commandes

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Commandes',
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
              // Ajoutez les boutons ici
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Bouton 1 pour "Buying"
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onButtonPressed(0),
                        child: Column(
                          children: [
                            Text(
                              'Achat',
                              style: TextStyle(
                                //color: Color(0xFF111928),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: _selectedIndex == 0
                                  ? theme
                                      ? Color.fromARGB(255, 249, 217, 144)
                                      : Color(0xFF111928)
                                  : Color(
                                      0x26111928), // Change la couleur si sélectionné
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bouton 2 pour "Selling"
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onButtonPressed(1),
                        child: Column(
                          children: [
                            Text(
                              'Vente',
                              style: TextStyle(
                                //color: Color(0xFF111928),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: _selectedIndex == 1
                                  ? theme
                                      ? Color.fromARGB(255, 249, 217, 144)
                                      : Color(0xFF111928)
                                  : Color(
                                      0x26111928), // Change la couleur si sélectionné
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Affichage du contenu basé sur l'état
              Expanded(
                child: _selectedIndex == 0
                    ? orderData == null || orderData.isEmpty
                        ? const Center(
                            child: Text(
                            'Aucune commande trouvée.',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.40,
                            ),
                            textAlign: TextAlign.center,
                          ))
                        : _buildContentA(orderData) // Affiche le contenu A
                    : Consumer<AuthService>(
                        builder: (context, provider, child) {
                          final orderSellData = provider
                              .orderselldata; // Accédez à la liste des ventes

                          return orderSellData==null || orderSellData.isEmpty
                              ? const Center(
                                  child: Text(
                                  'Aucune vente trouvée.',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.40,
                                  ),
                                  textAlign: TextAlign.center,
                                ))
                              : _buildContentB(
                                  orderSellData); // Affiche le contenu B
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
