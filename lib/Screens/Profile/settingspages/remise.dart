import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class DiscountPage extends StatefulWidget {
  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  bool applyDiscount = false;
  TextEditingController discountController = TextEditingController();
  String errorMessage = "";
  bool isLoading = false;

  // Fonction pour appeler l'API et appliquer la remise
  Future<void> applyDiscountToProducts() async {
    setState(() {
      errorMessage = "";
    });

    if (applyDiscount && discountController.text.isNotEmpty) {
      int? discount = int.tryParse(discountController.text);

      if (discount != null && discount > 0 && discount <= 100) {
        setState(() {
          isLoading = true;
        });

        try {
          int userId = Provider.of<AuthService>(context, listen: false)
              .currentUser!
              .id; // Exemple d'ID utilisateur, remplacez par la logique de récupération de l'ID de l'utilisateur

          // URL de l'API backend
          final url = Uri.parse(
              '${AppConfig.baseUrl}/api/products/apply_discount_to_user_products/$userId/${discount.toInt()}/');
          final body = json.encode({
            'discount_percentage': discount,
          });
          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: body,
          );

          if (response.statusCode == 200) {
            Provider.of<AuthService>(context, listen: false).sendNotifToAllUsers(
                "Remise !",
                "${Provider.of<AuthService>(context, listen: false).currentUser!.fullName} à fait un remise sur ces produits",
                Provider.of<AuthService>(context, listen: false).currentUser!.avatar!,
                Provider.of<AuthService>(context, listen: false).currentUser!.id,
                );
            // Si la remise est appliquée avec succès
            print("Remise de $discount% appliquée avec succès !");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Succès"),
                  content: Text(
                      "La remise de $discount% a été appliquée à tous vos produits."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          } else {
            // Si l'API retourne une erreur
            setState(() {
              errorMessage = "Une erreur s'est produite, veuillez réessayer.";
            });
          }
        } catch (e) {
          setState(() {
            errorMessage = "Erreur de connexion. Veuillez réessayer plus tard.";
          });
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              "Veuillez entrer un pourcentage valide entre 1 et 100.";
        });
      }
    } else {
      setState(() {
        errorMessage = "Le champ de remise est vide.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Appliquer une Remise",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.50,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "En appliquant la remise, tous les utilisateurs de Finos seront avertis. Vous aurez de plus fortes chances de vendre !",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: const Color(0xFFFFDEC3),
                  value: applyDiscount,
                  onChanged: (value) {
                    setState(() {
                      applyDiscount = value!;
                      errorMessage = "";
                    });
                  },
                ),
                Text(
                  "Appliquer une remise sur tous mes produits",
                  style: TextStyle(fontFamily: 'Raleway'),
                ),
              ],
            ),
            if (applyDiscount) ...[
              SizedBox(height: 10),
              CustomTextFormField(
                controller: discountController,
                keyboardType: TextInputType.number,
                isPassword: false,
                label: 'Remise',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                      2), // Pour limiter à 2 chiffres max
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[2-7]?\d?$|^80$')), // Accepte 20 à 80
                ],
              ),
              Text(
                "Veuillez entrer une valeur entre 20 et 80.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Raleway',
                ),
              ),
              if (errorMessage.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: 'Raleway',
                  ),
                ),
              ],
              SizedBox(height: 20),
              CustomButton(
                onTap: isLoading ? () {} : applyDiscountToProducts,
                label: isLoading ? 'Chargement...' : 'Appliquer la remise',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
