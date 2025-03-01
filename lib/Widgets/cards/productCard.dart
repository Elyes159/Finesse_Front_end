import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String productPrice;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

Widget _buildImage(String imageUrl) {
  // Vérifie si l'URL commence par "assets" pour déterminer s'il s'agit d'une image locale
  if (imageUrl.startsWith('assets')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  } else {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
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
          '${widget.productPrice}',
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
