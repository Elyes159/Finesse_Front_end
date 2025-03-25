import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Screens/HomeScreens/wish.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:finesse_frontend/Screens/Profile/contact.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/account.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/annonce.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/badges.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/cg.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/faq.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/orders.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/privacupolicy.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/remise.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/settingapp.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/vancance.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/viewed.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/virementbANK.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/logout.dart';
import 'package:finesse_frontend/Widgets/settings/containerinsettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Parametres extends StatefulWidget {
  const Parametres({super.key});

  @override
  State<Parametres> createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthService>(context, listen: false).fetchOrders(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
    Provider.of<AuthService>(context, listen: false).fetchSellingOrders(
        Provider.of<AuthService>(context, listen: false).currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              'Paramètres',
              style: TextStyle(
                //color: Color(0xFF111928),
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Badges()));
            },
            child:
                SettingsTile(iconPath: "assets/Icons/cup.svg", title: "Badges"),
          ),
          Divider(),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileMain()));
            },
            child: SettingsTile(title: "Mon profil"),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Account()));
            },
            child: SettingsTile(
                iconPath: "assets/Icons/icon-3.svg", title: "Compte"),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Annonce()));
            },
            child: SettingsTile(
              height: 25,
              iconPath: "assets/Icons/annonce.svg",
              title: "Annonce",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Orders()));
            },
            child: SettingsTile(
                iconPath: "assets/Icons/box.svg", title: "Commandes"),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Viewed()));
            },
            child: SettingsTile(
              iconPath: "assets/Icons/box.svg",
              title: "Récemment vus",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WishList()));
            },
            child: SettingsTile(
              iconPath: "assets/Icons/heartt.svg",
              title: "Favories",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DiscountPage()));
            },
            child: SettingsTile(
              iconPath: "assets/Icons/icon-4.svg",
              title: "Remises",
            ),
          ),
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Vacance()));
              },
              child: SettingsTile(
                  iconPath: "assets/Icons/holiday.svg",
                  height: 25,
                  title: "Mode vancance")),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BankTransferForm()));
              },
              child: SettingsTile(
                  iconPath: "assets/Icons/icon-7.svg",
                  title: "Recevoir par virement")),
          SettingsTile(
            iconPath: "assets/Icons/moon.svg",
            title: "Thème sombre",
            hasSwitch: true,
            switchValue: themeProvider.isDarkMode,
            onToggle: (value) {
              themeProvider.toggleTheme();
            },
          ),
          SizedBox(height: 46),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Paramètres',
              style: TextStyle(
                //color: Color(0xFF111928),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppSetting()));
              },
              child: SettingsTile(
                  iconPath: "assets/Icons/icon-5.svg",
                  title: "Paramètres de l'App")),
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FAQPage()));
              },
              child: SettingsTile(
                  iconPath: "assets/Icons/icon-6.svg", title: "FAQ")),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()));
              },
              child: SettingsTile(
                  iconPath: "assets/Icons/icon-6.svg",
                  title: "Politique de confidentialité")),
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Contact()));
              },
              child: SettingsTile(
                  iconPath: "assets/Icons/icon-6.svg",
                  title: "Nous contacter")),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: CustomButtonLogOut(
              label: "Déconnexion",
              onTap: () {
                Provider.of<AuthService>(context, listen: false).signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                  (Route<dynamic> route) =>
                      false, // Supprime toutes les routes précédentes
                );
              },
              textColor: theme ? Colors.black : Colors.white,
              buttonColor: theme ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditionsPage()));
            },
            child: Center(
              child: Text(
                "Conditions générales",
                style: TextStyle(
                  fontFamily: "Raleway",
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(child: Text("Version 1.0.0" , style: TextStyle(color: Colors.grey),))
        ],
      ),
    );
  }
}
