import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  const CustomTextFormField({
    required this.controller,
    required this.label,
    required this.isPassword,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  void _togglePasswordVisibility(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
       decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFF5C7CA4)),
        borderRadius: BorderRadius.circular(8),
        ),
        ),
        child: Center(
          child: TextFormField(
            cursorColor: Colors.grey,
            cursorHeight: 20,
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              suffixIcon: widget.isPassword? GestureDetector( onTap:_togglePasswordVisibility,child: SvgPicture.asset("assets/Icons/eye.svg",height: 24,width: 24,)): null,
              
              labelText: widget.label,
              labelStyle: TextStyle(
                color: Color(0xFF3E536E),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: 0.50,
              ),
              
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 10),
            ),
          ),
        ),
      ),
    );
  }
}