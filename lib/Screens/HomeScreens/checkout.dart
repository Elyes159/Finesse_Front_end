import 'dart:async';
import 'dart:convert';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/HomeScreens/livraison.dart';
import 'package:finesse_frontend/Screens/HomeScreens/paymentpage.dart';
import 'package:finesse_frontend/Screens/Profile/settingspages/account.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customfieldbuton.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CheckoutPage extends StatefulWidget {
  final List<dynamic> productIds;
  final double subtotal;
  double total;

  CheckoutPage({
    super.key,
    required this.productIds,
    required this.subtotal,
    required this.total,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _promoCodeController = TextEditingController();
  String _promoCode = '';
  String _selectedPaymentMethod = 'Cash on Delivery';
  bool verified = false;
  late Map data = {};
  double deliveryFee = 7.00;
  Future<bool> initiateFlouciPayment(
      BuildContext context, double amount) async {
    int amountInMillimes = (amount * 1000).toInt();
    print("Envoi du montant en millimes: $amountInMillimes");

    final response = await http.post(
      Uri.parse("${AppConfig.baseUrl}/api/products/create-payment/"),
      headers: {
        "Authorization": "Bearer f6a54269-3908-4457-86ff-692dc4d67167",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"amount": amountInMillimes}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final paymentUrl = data["link"];

      // Remplace ces URLs par tes propres liens
      final successUrl = "https://elyes158.github.io/success_finesse/";
      final failUrl = "https://elyes158.github.io/fail_finesse/";

      bool? paymentStatus = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(
            paymentUrl: paymentUrl,
            successUrl: successUrl,
            failUrl: failUrl,
          ),
        ),
      );
      print("payment status : $paymentStatus");
      return paymentStatus ?? false;
    } else {
      print("Erreur lors de la création du paiement.");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Écouter les liens entrants
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool promo = false;
  double? promoprix;
  void _applyPromoCode() async {
    _promoCode = _promoCodeController.text;

    bool isValid = await Provider.of<Products>(context, listen: false)
        .checkPromoCode(_promoCode);

    if (isValid) {
      setState(() {
        promo = true;
        double discount =
            Provider.of<Products>(context, listen: false).discount ?? 0;
        promoprix = widget.total - (widget.total * discount / 100);
        widget.total = promoprix ?? widget.total;
      });
    } else {
      setState(() {
        promoprix = widget.total;
        promo = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paiement',
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/Icons/MapPin.svg",
                  color: theme ? Colors.white : null,
                ),
                SizedBox(width: 16),
                Text(
                  'Addresse',
                  style: TextStyle(
                    //color: Color(0xFF111928),
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: 0.50,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Consumer<AuthService>(
                      builder: (context, authService, child) {
                        final address = authService.currentUser?.address ?? "";
                        return Text(
                          address != "" ? address : "À compléter",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: address == ""
                                ? Color(0xFFBA1A1A)
                                : theme
                                    ? Colors.white
                                    : Color(0xFF111928),
                            fontSize: 11,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Account()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(
                            8.0), // Pour ajouter de l'espace autour du texte
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Couleur de la bordure
                            width: 1.0, // Épaisseur de la bordure
                          ),
                          borderRadius: BorderRadius.circular(
                              8), // Rayon de la bordure (arrondi)
                        ),
                        child: Text(
                          "Modifier",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Raleway",
                              fontSize:
                                  16), // Vous pouvez ajuster la taille du texte ici
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),

          // Champ de code promo dans un Row
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/Icons/Tag.svg",
                  color: theme ? Colors.white : null,
                ),
                SizedBox(width: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Code Promo',
                    style: TextStyle(
                      //color: Color(0xFF111928),
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CustomTextFormFieldwithButton(
                    controller: _promoCodeController,
                    label: "EX : ABC123",
                    isPassword: false,
                    onButtonPressed: () async {
                      if (promo) {
                        return;
                      }
                      _applyPromoCode();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),
          SizedBox(height: 25),

          // Sous-total et Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sous-total:',
                style: TextStyle(
                  //color: Color(0xFF111928),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                  letterSpacing: 0.15,
                ),
              ),
              Text(
                '${widget.subtotal.toStringAsFixed(2)} DT',
                style: TextStyle(
                  //color: Color(0xFF111928),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Livraison:',
                style: TextStyle(
                  //color: Color(0xFF111928),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                  letterSpacing: 0.15,
                ),
              ),
              const Text(
                '7.00 DT',
                style: TextStyle(
                  //color: Color(0xFF111928),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total du magasin:',
                style: TextStyle(
                  //color: Color(0xFF111928),
                  fontSize: 22,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.27,
                ),
              ),
              Text(
                '${widget.total.toStringAsFixed(2)} DT',
                style: TextStyle(
                  //color: Color(0xFF111928),
                  fontSize: 22,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.27,
                ),
              ),
            ],
          ),
          SizedBox(height: 55),
          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/Icons/Wallet.svg",
                          color: theme ? Colors.white : null,
                        ), // Icône Cash
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Paiement à la livraison",
                              style: TextStyle(
                                //color: Color(0xFF111928),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: 0.50,
                              ),
                            ),
                            Text(
                              '${widget.total.toStringAsFixed(2)} DT',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          activeColor:
                              theme ? Color.fromARGB(255, 249, 217, 144) : null,
                          value: "Cash on Delivery",
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/Icons/CreditCard.svg",
                          color: theme ? Colors.white : null,
                        ), // Icône Cash

                        SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Paiement par carte",
                              style: TextStyle(
                                //color: Color(0xFF111928),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: 0.50,
                              ),
                            ),
                            Text(
                              '${widget.total.toStringAsFixed(2)} DT',
                              style: TextStyle(
                                //color: Color(0xFF3E536E),
                                fontSize: 14,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          activeColor:
                              theme ? Color.fromARGB(255, 249, 217, 144) : null,
                          value: "Payment with Card",
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 43,
          ),
          CustomButton(
              buttonColor: Color(0xFFC668AA),
              label: "Continuer",
              onTap: () async {
                if (_selectedPaymentMethod == "Payment with Card") {
                  bool payed =
                      await initiateFlouciPayment(context, widget.total);
                  if (payed) {
                    double totalWithDelivery =
                        (promoprix ?? widget.total) + deliveryFee;
                    bool ordered =
                        await Provider.of<Products>(context, listen: false)
                            .createOrder(
                      Provider.of<AuthService>(context, listen: false)
                          .currentUser!
                          .id,
                      widget.productIds,
                      "paye",
                      totalWithDelivery.toInt(),
                    );
                    if (ordered) {
                      Provider.of<Products>(context, listen: false)
                          .getFavourite(
                              Provider.of<AuthService>(context, listen: false)
                                  .currentUser!
                                  .id);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Livraison()),
                        (Route<dynamic> route) =>
                            false, // Supprime toutes les routes précédentes
                      );
                    }
                  }
                } else {
                  double totalWithDelivery =
                      (promoprix ?? widget.total) + deliveryFee;
                  bool ordered =
                      await Provider.of<Products>(context, listen: false)
                          .createOrder(
                    Provider.of<AuthService>(context, listen: false)
                        .currentUser!
                        .id,
                    widget.productIds,
                    "livraison",
                    totalWithDelivery.toInt(),
                  );
                  if (ordered) {
                    Provider.of<Products>(context, listen: false).getFavourite(
                        Provider.of<AuthService>(context, listen: false)
                            .currentUser!
                            .id);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Livraison()),
                      (Route<dynamic> route) =>
                          false, // Supprime toutes les pages précédentes
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
