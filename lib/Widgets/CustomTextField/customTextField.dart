import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final bool? enabled;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final String? defaultValue; // Texte par défaut

  CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.isPassword,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
    this.defaultValue,  this.enabled, // Valeur par défaut optionnelle
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;
  String? _errorMessage; // Message d'erreur
  bool _isTouched = false; // Indique si le champ a été touché

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {
        _errorMessage = widget.validator?.call(widget.controller.text); // Validation
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialiser le texte par défaut si défini
    if (widget.defaultValue != null && widget.defaultValue!.isNotEmpty) {
      widget.controller.text = widget.defaultValue!;
    }
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context,listen:false).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: theme ? Color.fromARGB(255, 249, 217, 144) : Color(0xFF5C7CA4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: TextFormField(
              enabled: widget.enabled ?? true,
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
                          _obscureText
                              ? "assets/Icons/eye-slash.svg" // Default "eye-slash" icon
                              : "assets/Icons/eye.svg", // When clicked, "eye" icon
                          height: 24,
                          width: 24,
                        ),
                      )
                    : null,
                labelText: widget.label,
                labelStyle: const TextStyle(
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
