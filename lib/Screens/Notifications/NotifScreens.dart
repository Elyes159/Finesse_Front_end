import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Notifications.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotifScreen extends StatefulWidget {
  @override
  _NotifScreenState createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  @override
  void initState() {
    super.initState();
    // Utilisation de addPostFrameCallback pour appeler fetchNotifications après la phase de build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Appel de la fonction pour récupérer les notifications après la phase de construction
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications(
              Provider.of<AuthService>(context, listen: false).currentUser!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            //color: Colors.black,
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.50,
          ),
        ),
      ),
      body: notificationProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notificationProvider.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationProvider.notifications[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        50), // Rend l'image totalement arrondie
                    child: Image.network(
                      notification.image,
                      width: 50, // Ajuste la taille de l'image
                      height: 50, // Ajuste la taille de l'image
                      fit: BoxFit
                          .cover, // Assure un bon ajustement dans le cadre
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error), // Gère les erreurs de chargement
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    // Navigation vers le profil du membre
                    await Provider.of<Profileprovider>(context, listen: false)
                        .fetchProfile(notification.notifier_id);
                    await Provider.of<Products>(context, listen: false)
                        .getProductsByUserVisited(notification.notifier_id);
                    await Provider.of<Products>(context, listen: false)
                        .getRatingByRatedUserVisited(
                      userId: notification.notifier_id,
                    );
                    await Provider.of<Products>(context, listen: false)
                        .checkOrderedorNot(
                            first_id:
                                Provider.of<AuthService>(context, listen: false)
                                    .currentUser!
                                    .id,
                            second_id: notification.notifier_id);
                    await Provider.of<Products>(context, listen: false)
                        .getFollowersVisited(notification.notifier_id);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileMain(id: notification.notifier_id)),
                    );
                  },
                );
              },
            ),
    );
  }
}
