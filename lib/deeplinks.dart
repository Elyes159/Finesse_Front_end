import 'dart:async';
import 'dart:convert'; // Pour utiliser Uri.decodeComponent
import 'package:app_links/app_links.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';

class DeepLinksListener extends StatefulWidget {
  final Widget child;
  const DeepLinksListener({super.key, required this.child});

  @override
  _DeepLinksListenerState createState() => _DeepLinksListenerState();
}

class _DeepLinksListenerState extends State<DeepLinksListener> {

  late StreamSubscription uriStreamSubscription;

  @override
  void initState() {
    super.initState();
    final applinks = AppLinks();
    uriStreamSubscription = applinks.uriLinkStream.listen(
      (uri) async {
        final pathSegments = uri.pathSegments;
        if (pathSegments.isNotEmpty) {
          // Extrait la dernière partie du chemin
          final idString = pathSegments.last;
          String decodedId = Uri.decodeComponent(idString);
          print('ID brut: $idString');
          print('ID décodé avant nettoyage: $decodedId');

          decodedId = decodedId.replaceAll('%25', '%');

          decodedId = decodedId.replaceAll(RegExp(r'\D'), '');
          print('ID décodé après nettoyage: $decodedId');
          final id = int.tryParse(decodedId);
          if (id != null && mounted) {
            print('ID récupéré: $id');

            try {
              // Effectuer les appels API ou les actions liées à l'ID
              await Provider.of<Profileprovider>(context, listen: false)
                  .fetchProfile(id);

              await Provider.of<Products>(context, listen: false)
                  .getProductsByUserVisited(id);

              await Provider.of<Products>(context, listen: false)
                  .getProductsSelledByUserVisited(id);

              await Provider.of<Products>(context, listen: false)
                  .getRatingByRatedUserVisited(userId: id);

              await Provider.of<Products>(context, listen: false)
                  .checkOrderedorNot(
                      first_id: Provider.of<AuthService>(context, listen: false)
                          .currentUser!
                          .id,
                      second_id: id);

              await Provider.of<Products>(context, listen: false)
                  .getFollowersVisited(id);

              await Provider.of<Products>(context, listen: false)
                  .getFollowingVisited(id);

              // Navigation vers le profil de l'utilisateur
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileMain(id: id),
                ),
              );
            } catch (e) {
              print('Erreur lors de l\'appel API ou navigation: $e');
            }
          } else {
            print('ID invalide ou non récupéré');
          }
        }
      },
    );
  }

  @override
  void dispose() {
    // Annuler l'abonnement quand le widget est démonté
    uriStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
