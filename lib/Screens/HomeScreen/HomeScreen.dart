import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: user.avatar != ""
                ? NetworkImage(widget.parameter == "normal"
                    ? "${AppConfig.TestClientUrl}${user.avatar}"
                    : user.avatar!)
                : AssetImage('assets/images/user.png') as ImageProvider, // Image locale si avatar est null
            backgroundColor: Colors.transparent,
            child: user.avatar == null
                ? const CircularProgressIndicator()
                : null,
          ),
          const SizedBox(height: 20), // Espacement entre l'avatar et le texte
          // Ajouter du texte pour afficher le nom de l'utilisateur
          Text(
            'Welcome, ${user.fullName}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
