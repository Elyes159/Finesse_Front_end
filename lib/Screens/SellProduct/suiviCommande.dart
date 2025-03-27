import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Widgets/orderstep.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTrackingPage extends StatefulWidget {
  final order;
  const OrderTrackingPage({super.key, required this.order});

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  List<OrderStep> orderSteps = [
    OrderStep("En attente de confirmation", "25/03/2025 11:29", true),
    OrderStep("Confirmée", "25/03/2025 11:55", true,
        description:
            "La commande est confirmée, nous venons de l'assigner à la société de livraison et nous avons demandé au vendeur de préparer le colis."),
    OrderStep("Envoyée", "", true),
    OrderStep("Reçue", "", true),
    OrderStep("Finalisée", "", true),
  ];
  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat("dd/MM/yyyy HH:mm").format(parsedDate);
  }

  @override
  void initState() {
    super.initState();
    orderSteps = [
      OrderStep("En attente de confirmation",
          formatDate(widget.order["created_at"]), true),
      if (widget.order["annule"] == true)
        OrderStep(
            "Annulé",
            "Votre commande a été annulée en raison de : ${widget.order["raison_annulation"]}. "
                "Nous nous excusons pour la gêne occasionnée et vous invitons à contacter le service client pour plus d’informations.",
            widget.order["annule"]),
      OrderStep(
        "Confirmée",
        formatDate(widget.order["date_confirmed"]),
        widget.order["confirmed"] ?? false,
        description:
            "La commande est confirmée, nous venons de l'assigner à la société de livraison et nous avons demandé au vendeur de préparer le colis.",
      ),
      OrderStep("Envoyée", "", widget.order["sent"] ?? false),
      OrderStep("Reçue", "", widget.order["recu"] ?? false),
      OrderStep("Finalisée", "", widget.order["finalise"] ?? false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la commande",
            style: TextStyle(
              //color: Color(0xFF111928),
              fontSize: 16,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
              height: 1.25,
              letterSpacing: 0.50,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Produit
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${AppConfig.baseUrl}${widget.order["product"]["images"][0]}",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text("${widget.order["product"]["title"]}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Commandé : ${formatDate(widget.order["product"]["created_at"])}",
                        style: TextStyle(fontFamily: "Raleway")),
                    SizedBox(height: 4),
                    if (widget.order["finalise"] == true)
                      Text("Finalisé",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              color: Colors.green,
                              fontWeight: FontWeight.w500))
                    else if (widget.order["recu"] == true)
                      Text("Reçue",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              color: Colors.green,
                              fontWeight: FontWeight.w500))
                    else if (widget.order["sent"] == true)
                      Text("Envoyée",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              color: Colors.green,
                              fontWeight: FontWeight.w500))
                    else if (widget.order["confirmee"] == true)
                      Text("Confirmé",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              color: Colors.green,
                              fontWeight: FontWeight.w500))
                    else if (widget.order["annule"] == true)
                      Text("Annulé",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              color: Colors.red,
                              fontWeight: FontWeight.w500))
                    else
                      Text("En attente de confirmation".toUpperCase(),
                          style: TextStyle(
                              fontFamily: "Raleway",
                              color: Colors.blue,
                              fontWeight: FontWeight.w500))
                  ],
                ),
                trailing: Text("${widget.order["product"]["price"]}",
                    style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
            ),

            const SizedBox(height: 16),

            // Titre suivi
            const Text("Avancement de la commande",
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: orderSteps.length,
                itemBuilder: (context, index) {
                  return OrderStepTile(step: orderSteps[index]);
                },
              ),
            ),

            if (widget.order["suivi_aramex"] != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Suivi ARAMEX | ",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            color: Colors.red,
                            fontSize: 16)),
                    Text(
                      widget.order["suivi_aramex"] == "Autres"
                          ? "_____"
                          : "${widget.order["suivi_aramex"]}",
                      style: const TextStyle(
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
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
