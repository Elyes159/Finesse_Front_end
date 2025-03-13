import 'package:flutter/material.dart';

class ContactButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const ContactButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 343,
      height: 48,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 343,
              height: 48,
              decoration: ShapeDecoration(
                color: const Color(0xFF0C0C0C),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0x19C9D7F1)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Positioned(
            left: 17.59,
            top: 12,
            child: SizedBox(
              width: 24,
              height: 24,
              child: Icon(icon, color: Colors.white),
            ),
          ),
          Positioned(
            left: 67.06,
            top: 18,
            child: SizedBox(
              width: 70.36,
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFFD7DFEE),
                  fontSize: 14,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
