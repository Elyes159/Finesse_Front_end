import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String productPrice;
  const ProductCard({super.key, required this.imageUrl, required this.productName, required this.productPrice});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(widget.imageUrl,height: 120,),
        const SizedBox(height: 6,),
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
        const SizedBox(height: 4,),
        Text(
            '${widget.productPrice} TND',
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