import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color buttonColor; // Variable for the button color
  final Color textColor; // Variable for the text color
  final bool isDisabled; // New variable for the disabled state

  const CustomButton({
    required this.label,
    required this.onTap,
    this.buttonColor = const Color(0xFFFB98B7), // Default button color
    this.textColor = Colors.white, // Default text color
    this.isDisabled = false, // Default to enabled
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap, // Disable interaction if isDisabled is true
      child: Padding(
        padding: const EdgeInsets.only(right: 0, left: 0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey // Grey out the button if disabled
                : buttonColor, // Use the passed button color if enabled
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDisabled
                      ? Colors.black54 // Use a faded text color if disabled
                      : textColor, // Use the passed text color if enabled
                  fontSize: 14,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  letterSpacing: 0.10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
