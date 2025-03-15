import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SettingsTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final bool hasSwitch;
  final double? width;
  final double? height;
  final bool switchValue;
  final ValueChanged<bool>? onToggle;

  const SettingsTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onToggle,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

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
                SvgPicture.asset(
                  iconPath,
                  color: theme ? Colors.white : null,
                  height: height ?? null,
                  width: width ?? null,
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    //color: Color(0xFF111928),
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
            SvgPicture.asset("assets/Icons/icon-2.svg",
                color: theme ? Colors.white : null)
        ],
      ),
    );
  }
}
