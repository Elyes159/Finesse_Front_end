import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: ShapeDecoration(
            color: isSelected ? Colors.blue : const Color(0xFFE5E7EB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF111928),
              fontSize: 12,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
              height: 1.67,
            ),
          ),
        ),
      ),
    );
  }
}
