import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


class SettingsTile extends StatelessWidget {
  final String? iconPath;
  final String title;
  final bool hasSwitch;
  final double? width;
  final double? height;
  final bool switchValue;
  final ValueChanged<bool>? onToggle;

  const SettingsTile({
    super.key,
    this.iconPath,
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
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;

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
                CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: (iconPath != null && iconPath!.isNotEmpty)
                      ? (iconPath!.startsWith('http') || iconPath!.startsWith('assets'))
                          ? AssetImage(iconPath!) as ImageProvider
                          : null
                      : (user.avatar != "" && user.avatar != null)
                          ? NetworkImage(
                              user.avatar!.startsWith("http")
                                  ? user.avatar!
                                  : "${AppConfig.baseUrl}${user.avatar}"
                            )
                          : const AssetImage('assets/images/user.png'),
                  child: (iconPath == null || iconPath!.isEmpty) && user.avatar == null
                      ? Container()
                      : (iconPath != null && iconPath!.endsWith('.svg'))
                          ? SvgPicture.asset(
                              iconPath!,
                              color: theme ? Colors.white : null,
                              height: height ?? 24,
                              width: width ?? 24,
                            )
                          : null,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
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
                color: theme ? Colors.white : null),
        ],
      ),
    );
  }
}
