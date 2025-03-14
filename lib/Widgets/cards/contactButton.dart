import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const ContactButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context,listen: false).isDarkMode;
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth,
              height: 60,
              decoration: ShapeDecoration(
                color: theme ? Color(0xFF0C0C0C) : Colors.white,
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
              child: Icon(icon, color: theme ? Colors.white : Colors.black),
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
