import 'package:flutter/material.dart';

class OrderStep {
  final String title;
  final String date;
  final bool isCompleted;
  final String? description;

  OrderStep(this.title, this.date, this.isCompleted, {this.description});
}

// Widget pour afficher une étape du suivi
class OrderStepTile extends StatelessWidget {
  final OrderStep step;

  const OrderStepTile({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              step.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: step.isCompleted ? Colors.green : Colors.grey,
            ),
            Container(
              width: 2,
              height: 40,
              color: step.isCompleted ? Colors.green : Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: step.isCompleted ? Colors.black : Colors.grey)),
                  if (step.date.isNotEmpty)
                    Text(step.date, style: const TextStyle(color: Colors.grey)),
                  if (step.description != null) ...[
                    const SizedBox(height: 4),
                    Text(step.description!,
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}