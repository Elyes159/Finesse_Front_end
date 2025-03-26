import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Widgets/orderstep.dart';
import 'package:flutter/material.dart';

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
@override
void initState() {
  super.initState();
  orderSteps = [
    OrderStep("En attente de confirmation", "25/03/2025 11:29", true),
    
    if (widget.order["annule"] == true)
      OrderStep("Annulé", "", widget.order["annule"]),

    OrderStep(
      "Confirmée",
      "${widget.order["date_confirmed"]}",
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
        title: const Text("Détails de la commande"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
                title:  Text("${widget.order["product"]["title"]}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Commandé : ${widget.order["product"]["created_at"]}"),
                    SizedBox(height: 4),
                    Text("CONFIRMÉE",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold))
                  ],
                ),
                trailing: const Text("150 DT",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 16),

            // Titre suivi
            const Text("Avancement de la commande",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: orderSteps.length,
                itemBuilder: (context, index) {
                  return OrderStepTile(step: orderSteps[index]);
                },
              ),
            ),

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
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                  Text("50371394043",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
