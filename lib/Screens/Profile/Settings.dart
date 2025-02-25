import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/account.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/boost.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/orders.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/settingapp.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/viewed.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/settings/containerinsettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthService>(context,listen: false).fetchOrders(Provider.of<AuthService>(context,listen:false).currentUser!.id);
        Provider.of<AuthService>(context,listen: false).fetchSellingOrders(Provider.of<AuthService>(context,listen:false).currentUser!.id);

  }
 @override
Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context); // Ajoutez cette ligne

  return Scaffold(
    appBar: AppBar(
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Text(
            'Settings',
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
    body: ListView(
      padding: EdgeInsets.all(16),
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
          },
          child: SettingsTile(iconPath: "assets/Icons/icon-3.svg", title: "Account"),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Orders()));
          },
          child: SettingsTile(iconPath: "assets/Icons/box.svg", title: "Orders"),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Viewed()));
          },
          child: SettingsTile(
            iconPath: "assets/Icons/box.svg",
            title: "Recently seen",
          ),
        ),
        SettingsTile(
          iconPath: "assets/Icons/moon.svg",
          title: "Dark Theme",
          hasSwitch: true,
          switchValue: themeProvider.isDarkMode,
          onToggle: (value) {
            themeProvider.toggleTheme();
          },
        ),
        SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'COOL STUFF',
            style: TextStyle(
              color: Color(0xFF111928),
              fontSize: 14,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w500,
              height: 1.43,
              letterSpacing: 0.10,
            ),
          ),
        ),
        SizedBox(height: 18),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Boost()));
          },
          child: SettingsTile(iconPath: "assets/Icons/airplane.svg", title: "Boost")),
        SizedBox(height: 46),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Settings',
            style: TextStyle(
              color: Color(0xFF111928),
              fontSize: 14,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w500,
              height: 1.43,
              letterSpacing: 0.10,
            ),
          ),
        ),
        SizedBox(height: 18),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AppSetting()));
          },
          child: SettingsTile(iconPath: "assets/Icons/icon-5.svg", title: "App Settings")),
        SettingsTile(iconPath: "assets/Icons/icon-6.svg", title: "FAQ"),
        SettingsTile(iconPath: "assets/Icons/icon-6.svg", title: "Privacy Policy"),
        SettingsTile(iconPath: "assets/Icons/icon-6.svg", title: "Contact Us"),
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: CustomButton(
            label: "Log Out",
            onTap: () {
              Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
            buttonColor: Color(0xffEA4335),
          ),
        ),
      ],
    ),
  );
}

}
