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
  final ValueChanged<int> onItemSelected;
  final int currentIndex;

  const Navigation({
    Key? key,
    required this.onItemSelected,
    this.currentIndex = 0,
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
        SellProductScreen(),
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

    return Scaffold(
      body: _pages.isNotEmpty ? _pages[_selectedIndex] : Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/home.svg",
              color: _selectedIndex == 0 ? Color(0xFFFB98B7) : Colors.black,
              height: 24,
              width: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              height: 24,
              width: 24,
              "assets/Icons/explore.svg",
              color: _selectedIndex == 1 ? Color(0xFFFB98B7) : Colors.black,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: _selectedIndex == 2 ? Color(0xFFFB98B7) : Colors.black,
              size: 24,
            ),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Icons/notification.svg",
              color:
                  _selectedIndex == 3 ? const Color(0xFFFB98B7) : Colors.black,
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
                    ? Border.all(color: Color(0xFFFB98B7), width: 2)
                    : null,
              ),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: (user.avatar != "" && user.avatar != null)
                    ? NetworkImage(parametre == "normal"
                        ? "${AppConfig.baseUrl}${user.avatar}"
                        : user.avatar!)
                    : AssetImage('assets/images/user.png') as ImageProvider,
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
          color: Color(0xFFFB98B7),
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "Raleway",
          fontSize: 12,
          color: Colors.black,
        ),
        selectedItemColor: Color(0xFFFB98B7),
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
