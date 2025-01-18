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
  if (imageUrl.startsWith('assets')) {
    return Image.asset(
      imageUrl,
      height: 120,
    );
  } else {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8), // Arrondi des coins
      child: Image.network(
        imageUrl,
        height: 120,
        width: double.infinity, // Prend toute la largeur du conteneur
        fit: BoxFit.cover, // Étire l'image pour couvrir tout l'espace
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
            color: Colors.black,
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
            color: Colors.black,
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
