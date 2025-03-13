import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomContainer extends StatelessWidget {
  final void Function() onTap;
  final String imagePath;

  const CustomContainer({super.key, required this.onTap,required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Appel de la fonction onTap lorsqu'on clique sur le container
      child: Container(
        width: 74,
        height: 74,
        padding: const EdgeInsets.all(4),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color(0xFFF2F4F7)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40.83,
              height: 40.83,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: SvgPicture.asset(imagePath,width: 40.83,height: 40.83,),
            ),
          ],
        ),
      ),
    );
  }
}
