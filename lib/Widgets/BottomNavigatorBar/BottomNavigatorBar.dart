import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int> onItemSelected; // Callback pour notifier le parent du changement d'index
  final int currentIndex; // L'index sélectionné actuellement

  const CustomBottomNavigationBar({
    Key? key,
    required this.onItemSelected,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  String? parametre = "";

  @override
  void initState() {
    super.initState();
    _loadParameter();
  }

  Future<void> _loadParameter() async {
    parametre = await const FlutterSecureStorage().read(key: 'parametre');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;

    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onItemSelected,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/Icons/home.svg",
            color: widget.currentIndex == 0 ? Color(0xFFFB98B7) : Colors.black, // Icône en rose si sélectionnée
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/Icons/explore.svg",
            color: widget.currentIndex == 1 ? Color(0xFFFB98B7) : Colors.black, // Icône en rose si sélectionnée
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add,
            color: widget.currentIndex == 2 ? Color(0xFFFB98B7) : Colors.black, // Icône en rose si sélectionnée
            size: 24,
          ),
          label: 'Sell',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/Icons/notification.svg",
            color: widget.currentIndex == 3 ? const Color(0xFFFB98B7) : Colors.black, // Icône en rose si sélectionnée
          ),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: widget.currentIndex == 4
                  ? Border.all(color: Color(0xFFFB98B7), width: 2) // Bordure rose si "Profile" est sélectionné
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
        fontSize: 14, 
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
    );
  }
}
