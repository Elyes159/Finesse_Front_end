import 'package:flutter/material.dart';

class RatingPercentageRow extends StatelessWidget {
  final double stars;
  final double percentage;

  RatingPercentageRow({required this.stars, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${stars.toInt()}', // Convertit le double en entier
          style: TextStyle(
            //color: Color(0xFF333333),
            fontSize: 14,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.14,
          ),
        ),
        Text(
          ' ★', // Convertit le double en entier
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0XFFE4A70A),
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 140, // Barre de progression
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage / 100, // Ajuste la largeur selon le %
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0XFFE4A70A),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
