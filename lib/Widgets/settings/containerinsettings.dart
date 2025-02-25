import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final bool hasSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onToggle;

  SettingsTile({
    required this.iconPath,
    required this.title,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(iconPath),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF111928),
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          if (hasSwitch)
            Switch(
              value: switchValue,
              onChanged: onToggle,
            )
          else 
           SvgPicture.asset("assets/Icons/icon-2.svg")
        ],
      ),
    );
  }
}
