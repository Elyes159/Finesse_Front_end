import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
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
  final ValueChanged<int> onItemSelected;
  final int currentIndex;
  final product;


  const Navigation({
    Key? key,
    required this.onItemSelected,
    this.currentIndex = 0,
    this.product
  }) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  String? parametre = "";
  int _selectedIndex = 0;
  List<Widget> _pages = [];
  @override
  void initState() {
    super.initState();
    _loadParameter();
  }

  Future<void> _loadParameter() async {
    parametre = await const FlutterSecureStorage().read(key: 'parametre');
    setState(() {
      _pages = [
        HomeScreen(parameter: parametre!),
        Explore(),
        SellProductScreen(product: widget.product,),
        NotifScreen(),
        ProfileMain(),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemSelected(index);
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
                      ?  Color.fromARGB(255, 249, 217, 144)
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
                      ?  Color.fromARGB(255, 249, 217, 144)
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
                      ?  Color.fromARGB(255, 249, 217, 144)
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
                      ?  Color.fromARGB(255, 249, 217, 144)
                      : Color(0xFFFB98B7)
                  : theme
                      ? Colors.white
                      : Colors.black,
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
                      ? (theme
                          ? Border.all(color:  Color.fromARGB(255, 249, 217, 144), width: 2)
                          : Border.all(color: Color(0xFFFB98B7), width: 2))
                      : null),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage:  (user.avatar != "" && user.avatar != null)
                    ? NetworkImage(parametre == "normal"
                        ? "${AppConfig.baseUrl}${user.avatar}"
                        : user.avatar!)
                    : AssetImage('assets/images/user.png') as ImageProvider,
                backgroundColor: Colors.transparent,
                child: user.avatar == null ? Container() : null,
              ),
            ),
            label: "Profil",
          ),
        ],
        selectedLabelStyle: TextStyle(
          fontFamily: "Raleway",
          fontSize: 12,
          color: theme ?  Color.fromARGB(255, 249, 217, 144) : Color(0xFFFB98B7),
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: "Raleway",
          fontSize: 12,
          color: theme ? Colors.white  :Colors.black,
        ),
        selectedItemColor: theme ?  Color.fromARGB(255, 249, 217, 144) :  Color(0xFFFB98B7),
        unselectedItemColor:theme ? Colors.white : Colors.black,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
