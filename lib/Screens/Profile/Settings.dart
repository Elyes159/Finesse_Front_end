import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
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
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Settings"),),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/ArrowLeft.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0,right:8),
            child: CustomButton(label: "Log Out", onTap: (){
              Provider.of<AuthService>(context,listen:false).signOut();
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
            },buttonColor: Color(0xffEA4335),),
          )
        ],
      ),
    );
  }
}