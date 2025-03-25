import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String productPrice;
  const ProductCard(
      {super.key,
      required this.imageUrl,
      required this.productName,
      required this.productPrice});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

Widget _buildImage(String imageUrl) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(2), // Arrondi des coins
      child: Image.network(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/test1.png', // Image de secours
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ));
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(widget.imageUrl),
        const SizedBox(
          height: 6,
        ),
        Text(
          widget.productName,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w500,
            height: 1.54,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          widget.productPrice,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.67,
          ),
          textAlign: TextAlign.left,
        )
      ],
    );
  }
}
