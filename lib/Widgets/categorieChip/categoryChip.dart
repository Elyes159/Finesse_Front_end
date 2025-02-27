import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart'; // Importer le package pour SVG

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final String? iconPath; // Ajoutez un paramètre pour l'icône

  const CategoryChip({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.iconPath, // Paramètre optionnel pour l'icône
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: ShapeDecoration(
            color: isSelected
                ? theme
                    ? Color.fromARGB(255, 249, 217, 144)
                    : Colors.blue
                : const Color(0xFFE5E7EB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPath != null) // Vérifier si iconPath n'est pas null
                Container(
                  width: 24,
                  height: 24,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage(iconPath!),
                      fit: BoxFit.fill,
                    ),
                    shape: OvalBorder(),
                  ),
                ),
                SizedBox(width: 3,),
              Text(
                text,
                style: TextStyle(
                  color: isSelected
                      ? theme
                          ? Colors.black
                          : Colors.white
                      : const Color(0xFF111928),
                  fontSize: 12,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  height: 1.67,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
