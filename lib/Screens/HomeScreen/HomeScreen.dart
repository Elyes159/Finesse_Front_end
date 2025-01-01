import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String? parameter;
  const HomeScreen({Key? key , required this.parameter}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if(widget.parameter == "normal") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AuthService>(context, listen: false).loadUserData();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AuthService>(context, listen: false).loadUserGoogleData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;   
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top:20.0,left:20, right:10),
        child: SafeArea(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                  
                    radius: 50.0,
                    backgroundImage: user.avatar != ""
                        ? NetworkImage(widget.parameter == "normal"
                            ? "${AppConfig.baseUrl}${user.avatar}"
                            : user.avatar!
                            
                            )
                        : AssetImage('assets/images/user.png') as ImageProvider, // Image locale si avatar est null
                    backgroundColor: Colors.transparent,
                    child: user.avatar == null
                        ? const CircularProgressIndicator()
                        : null,
                  ),
                ),
                 const SizedBox(width: 14), // Espacement entre l'avatar et le texte
                Text(
                  'Hello, ${user.fullName.split(' ')[0]}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Raleway',
                  ),
                ),
              ],
            ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset("assets/Icons/heart.svg"),
              SvgPicture.asset("assets/Icons/fav.svg"),
            ],
           )
          ],
        ),
        ),
      ),
    );
  }
}
