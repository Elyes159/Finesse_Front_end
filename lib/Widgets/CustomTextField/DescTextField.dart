import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DescTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  DescTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.isPassword,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
  });

  @override
  State<DescTextField> createState() => _DescTextFieldState();
}

class _DescTextFieldState extends State<DescTextField> {
  bool _obscureText = true;
  String? _errorMessage; // Message d'erreur
  bool _isTouched = false; // Indique si le champ a été touché

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        _errorMessage = widget.validator?.call(widget.controller.text); // Validation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 119,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFF5C7CA4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: TextFormField(
              onSaved: widget.onSaved,
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              keyboardType: widget.keyboardType,
              cursorColor: Colors.grey,
              style: const TextStyle(fontFamily: 'Raleway'),
              onTap: () {
                setState(() {
                  _isTouched = true; // Champ touché
                });
              },
              decoration: InputDecoration(
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: SvgPicture.asset(
                          "assets/Icons/eye.svg",
                          height: 24,
                          width: 24,
                        ),
                      )
                    : null,
                labelText: widget.label,
                labelStyle: const TextStyle(
                  color: Color(0xFF3E536E),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10),
              ),
            ),
          ),
          // Affichage conditionnel du message d'erreur
          if (_isTouched && _errorMessage != null && _errorMessage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
