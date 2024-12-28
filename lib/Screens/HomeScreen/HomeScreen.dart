import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 @override
void initState() {
  super.initState();
  
  // Assurez-vous que loadUserData est exécuté après le cycle de vie de la construction
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<AuthService>(context, listen: false).loadUserData();
  });
}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;
    return Scaffold(
      body: Column(
        children: [

          CircleAvatar(
            radius: 50.0,
            backgroundImage: user.avatar != null
                ? NetworkImage("${AppConfig.TestClientUrl}${user.avatar}")
                : null,
            backgroundColor: Colors.transparent,
            child: user.avatar == null
                ? const CircularProgressIndicator()
                : null,
          )

          ,
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
