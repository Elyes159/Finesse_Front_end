import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/sellprovider.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/HomeScreens/Explore.dart';
import 'package:finesse_frontend/Screens/HomeScreens/HomeScreen.dart';
import 'package:finesse_frontend/Screens/Notifications/NotifScreens.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:finesse_frontend/Screens/Profile/Settings.dart';
import 'package:finesse_frontend/Screens/SellProduct/SellproductScreen.dart';
import 'package:finesse_frontend/deeplinks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  final ValueChanged<int> onItemSelected;
  final int currentIndex;
  final dynamic product;
  final String? category_for_field;
  final String? from_mv;
  final String? categoryForVm;
  final Function({String? categoryForField, String? fromMv})?
      onNavigateToExplore;
  const Navigation({
    super.key,
    required this.onItemSelected,
    this.currentIndex = 0,
    this.product,
    this.onNavigateToExplore,
    this.categoryForVm,
    this.category_for_field,
    this.from_mv,
  });

  @override
  State<Navigation> createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  String? parametre = "";
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadParameter();
    _selectedIndex = widget.currentIndex;
  }

  Future<void> _loadParameter() async {
    parametre = await const FlutterSecureStorage().read(key: 'parametre');
    setState(() {
      _pages = [
        DeepLinksListener(child: HomeScreen(parameter: parametre!)),
        Explore(
            category_for_field: widget.category_for_field,
            from_mv: widget.from_mv),
        SellProductScreen(
            category_for_field: widget.category_for_field,
            product: widget.product,
            categoryFromMv: widget.from_mv),
        NotifScreen(),
        Parametres()
      ];
    });
  }

  void _onItemTapped(int index) async {
    // Récupère le SellProductProvider pour vérifier si des champs sont remplis
    final sellProductProvider =
        Provider.of<SellProductProvider>(context, listen: false);

    // Vérifie si l'utilisateur essaie de quitter la page "SellProductScreen"
    if (_selectedIndex == 2 && index != 2) {
      // Si des champs sont remplis, affiche un dialog de confirmation avant de quitter la page
      if (sellProductProvider.isAnyFieldFilled()) {
        bool? confirmExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation',
                  style: TextStyle(
                      fontFamily: "Raleway",
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .isDarkMode
                          ? Colors.white
                          : Colors.black)),
              content: Text(
                  'Êtes-vous sûr de vouloir annuler les modifications?',
                  style: TextStyle(
                      fontFamily: "Raleway",
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .isDarkMode
                          ? Colors.white
                          : Colors.black)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Annule la navigation
                  },
                  child: Text('Non',
                      style: TextStyle(
                          fontFamily: "Raleway",
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    // Réinitialise les variables du provider à null avant de quitter
                    sellProductProvider.reset();
                    Navigator.of(context).pop(true); // Accepte la navigation
                  },
                  child: Text(
                    'Oui',
                    style: TextStyle(
                        fontFamily: "Raleway",
                        color:
                            Colors.red),
                  ),
                ),
              ],
            );
          },
        );

        // Si l'utilisateur confirme, on change l'onglet
        if (confirmExit ?? false) {
          setState(() {
            _selectedIndex = index; // Met à jour l'index sélectionné
          });
          widget.onItemSelected(
              index); // Appelle le callback pour changer d'onglet
        }
      } else {
        // Si aucune donnée n'est remplie, on peut quitter directement
        setState(() {
          _selectedIndex = index;
        });
        widget.onItemSelected(index);
      }
    } else {
      // Si l'utilisateur n'est pas sur "SellProductScreen", on continue normalement
      setState(() {
        _selectedIndex = index;
      });
      widget.onItemSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;
    bool theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      body: _pages.isNotEmpty ? _pages[_selectedIndex] : Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/home.svg",
              color: _selectedIndex == 0
                  ? theme
                      ? Color.fromARGB(255, 249, 217, 144)
                      : Color(0xFFFB98B7)
                  : theme
                      ? Colors.white
                      : Colors.black,
              height: 24,
              width: 24,
            ),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              height: 24,
              width: 24,
              "assets/Icons/explore.svg",
              color: _selectedIndex == 1
                  ? theme
                      ? Color.fromARGB(255, 249, 217, 144)
                      : Color(0xFFFB98B7)
                  : theme
                      ? Colors.white
                      : Colors.black,
            ),
            label: "Explorer",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: _selectedIndex == 2
                  ? theme
                      ? Color.fromARGB(255, 249, 217, 144)
                      : Color(0xFFFB98B7)
                  : theme
                      ? Colors.white
                      : Colors.black,
              size: 24,
            ),
            label: "Vendre",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/notification.svg",
              color: _selectedIndex == 3
                  ? theme
                      ? Color.fromARGB(255, 249, 217, 144)
                      : Color(0xFFFB98B7)
                  : theme
                      ? Colors.white
                      : Colors.black,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/setting.svg",
              color: _selectedIndex == 4
                  ? theme
                      ? Color.fromARGB(255, 249, 217, 144)
                      : Color(0xFFFB98B7)
                  : theme
                      ? Colors.white
                      : Colors.black,
            ),
            label: 'Paramétres',
          ),
          
        ],
        selectedLabelStyle: TextStyle(
          fontFamily: "Raleway",
          fontSize: 12,
          color: theme ? Color.fromARGB(255, 249, 217, 144) : Color(0xFFFB98B7),
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: "Raleway",
          fontSize: 12,
          color: theme ? Colors.white : Colors.black,
        ),
        selectedItemColor:
            theme ? Color.fromARGB(255, 249, 217, 144) : Color(0xFFFB98B7),
        unselectedItemColor: theme ? Colors.white : Colors.black,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
