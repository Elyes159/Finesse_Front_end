import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  bool _notificationsEnabled = false;

  Future<void> _checkNotificationPermission() async {
    var status = await Permission.notification.status;
    setState(() {
      _notificationsEnabled = status.isGranted;
    });
  }

  Future<void> _toggleNotificationPermission(bool value) async {
    if (value) {
      var status = await Permission.notification.request();
      if (status.isGranted) {
        setState(() {
          _notificationsEnabled = true;
        });
      } else {
        setState(() {
          _notificationsEnabled = false;
        });
      }
    } else {
      setState(() {
        _notificationsEnabled = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              'App Settings',
              style: TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Notification settings container
            Container(
              height: screenHeight * 0.1, // Dynamically set height
              width: double.infinity,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Silencier toutes les notifications',
                          style: TextStyle(
                            color: Color(0xFF202020),
                            fontSize: 14,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            height: 1.29,
                            letterSpacing: -0.14,
                          ),
                        ),
                        SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            'Désactiver les notifications pour\n une concentration ininterrompue.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              height: 1.40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: _toggleNotificationPermission,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Dynamic spacing
            // Delete account container
            Container(
              width: double.infinity,
              height: screenHeight * 0.1, // Dynamically set height
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Supprimer le compte',
                          style: TextStyle(
                            color: Color(0xFFEA4335),
                            fontSize: 14,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            height: 1.29,
                            letterSpacing: -0.14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ton compte et toutes ses données seront effacées',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            height: 1.40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Confirmation',
                                style: TextStyle(
                                  //color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w500,
                                  height: 1.43,
                                  letterSpacing: 0.10,
                                ),
                              ),
                              content: Text(
                                'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
                                style: TextStyle(
                                  //color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w500,
                                  height: 1.43,
                                  letterSpacing: 0.10,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Annuler',
                                    style: TextStyle(
                                      color: Colors.white,
                                      
                                      fontSize: 14,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w500,
                                      height: 1.43,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    bool deleted = await Provider.of<AuthService>(
                                            context,
                                            listen: false)
                                        .deleteUser(
                                            Provider.of<AuthService>(
                                                    context,
                                                    listen: false)
                                                .currentUser!
                                                .id);
                                    if (deleted) {
                                      Provider.of<AuthService>(context,
                                              listen: false)
                                          .signOut();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignInScreen()),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: screenWidth * 0.3, // Dynamically set width
                                    height: screenHeight * 0.05, // Dynamically set height
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 10),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFEA4335),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Supprimer',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w500,
                                            height: 1.43,
                                            letterSpacing: 0.10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 104, // Dynamically set height
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFEA4335),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Supprimer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
