import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating; // Note moyenne sur 5

  StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          // Afficher une étoile pleine
          return Icon(Icons.star, color: Colors.amber, size: 30);
        } else if (index < rating) {
          // Afficher une demi-étoile
          return Icon(Icons.star_half, color: Colors.amber, size: 30);
        } else {
          // Afficher une étoile vide
          return Icon(Icons.star_border, color: Colors.amber, size: 30);
        }
      }),
    );
  }
}