import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/HomeScreens/Explore.dart';
import 'package:finesse_frontend/Screens/HomeScreens/HomeScreen.dart';
import 'package:finesse_frontend/Screens/Notifications/NotifScreens.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:finesse_frontend/Screens/SellProduct/SellproductScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  final ValueChanged<int> onItemSelected; // Callback pour notifier le parent du changement d'index
  final int currentIndex; // L'index sélectionné actuellement

  const Navigation({
    Key? key,
    required this.onItemSelected,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<Navigation> createState() =>
      _NavigationState();
}

class _NavigationState extends State<Navigation> {
  String? parametre = "";
  int _selectedIndex = 0; // Indice sélectionné par défaut (0 pour Home)

  // Liste des pages à afficher en fonction de l'index sélectionné
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadParameter(); // Charger le paramètre avant de définir les pages
  }

  Future<void> _loadParameter() async {
    parametre = await const FlutterSecureStorage().read(key: 'parametre');
    
    // Initialiser la liste des pages après avoir chargé 'parametre'
    setState(() {
      _pages = [
        HomeScreen(parameter: parametre!),
        Explore(),
        SellProductScreen(),
        NotifScreen(),
        ProfileMain(),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Changer l'index sélectionné
    });
    widget.onItemSelected(index); // Notifier le parent du changement d'index
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;

    return Scaffold(
      body: _pages.isNotEmpty ? _pages[_selectedIndex] : Container(), // Affiche la page correspondante
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Utilisation de l'index sélectionné localement
        onTap: _onItemTapped, // Gère les changements d'index
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/home.svg",
              color: _selectedIndex == 0 ? Color(0xFFFB98B7) : Colors.black, // Couleur rose si sélectionnée
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/explore.svg",
              color: _selectedIndex == 1 ? Color(0xFFFB98B7) : Colors.black, // Couleur rose si sélectionnée
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: _selectedIndex == 2 ? Color(0xFFFB98B7) : Colors.black, // Couleur rose si sélectionnée
              size: 24,
            ),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/notification.svg",
              color: _selectedIndex == 3 ? const Color(0xFFFB98B7) : Colors.black, // Couleur rose si sélectionnée
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: _selectedIndex == 4
                    ? Border.all(color: Color(0xFFFB98B7), width: 2) // Bordure rose si sélectionné
                    : null,
              ),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: (user.avatar != "" && user.avatar != null)
                    ? NetworkImage(parametre == "normal"
                        ? "${AppConfig.baseUrl}${user.avatar}"
                        : user.avatar!)
                    : AssetImage('assets/images/user.png')
                        as ImageProvider, // Image locale si avatar est null
                backgroundColor: Colors.transparent,
                child: user.avatar == null
                    ? const CircularProgressIndicator()
                    : null,
              ),
            ),
            label: 'Profile',
          ),
        ],
        selectedLabelStyle: const TextStyle(
          fontFamily: "Raleway",
          fontSize: 12, 
          color: Color(0xFFFB98B7), // Couleur du label sélectionné
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "Raleway",
          fontSize: 12,
          color: Colors.black, // Couleur du label non sélectionné
        ),
        selectedItemColor: Color(0xFFFB98B7), // Couleur de l'élément sélectionné
        unselectedItemColor: Colors.black, // Couleur des éléments non sélectionnés
        type: BottomNavigationBarType.fixed, // Assurez-vous que le type est "fixed"
      ),
    );
  }
}

