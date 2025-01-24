import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/Profile/Settings.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({super.key});

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  String? parametre = "";
  int _selectedTabIndex = 0; // Onglet actuellement sélectionné

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
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;
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
                            ? "${AppConfig.TestClientUrl}${user.avatar}"
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
                        user.fullName,
                        style: TextStyle(
                          color: Color(0xFF111928),
                          fontSize: 20,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '422 Followers',
                        style: TextStyle(
                          color: Color(0xFF111928),
                          fontSize: 14,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
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

  // Contenu des onglets
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

  // Contenu pour l'onglet "Items"
  Widget _buildItemsTab() {
    // Utilisation de la liste des produits récupérés via le provider
    return Consumer<Products>(
      builder: (context, provider, child) {
        final products = provider.productsByUser;

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

            return ProductCard(
              imageUrl: imageUrl,
              productName: product['title'] as String,
              productPrice: '${product['price']} TND', // Formater le prix
            );
          },
        );
      },
    );
  }

  // Contenu pour l'onglet "Ratings"
  Widget _buildRatingsTab() {
    return const Center(
      child: Text(
        "Ratings Tab Content",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Contenu pour l'onglet "About"
  Widget _buildAboutTab() {
    return const Center(
      child: Text(
        "About Tab Content",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
