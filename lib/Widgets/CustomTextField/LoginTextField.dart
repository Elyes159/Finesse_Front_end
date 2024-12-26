import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.isPassword,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;
  bool _isTextEmpty = true;  // Pour vérifier si le texte est vide
  String? _errorMessage;  // Pour stocker l'erreur
  bool _isTouched = false; // Vérifie si le champ a été touché

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    // Écoute des changements dans le texte saisi
    widget.controller.addListener(() {
      setState(() {
        _isTextEmpty = widget.controller.text.isEmpty;
        _errorMessage = widget.validator?.call(widget.controller.text); // Vérifie si le texte est valide
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,  // Aligne le texte et l'erreur à gauche
        children: [
          Container(
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
                onSaved: widget.onSaved,
                validator: widget.validator,
                cursorColor: Colors.grey,
                style: TextStyle(
                  fontFamily: 'Raleway',
                ),
                cursorHeight: 20,
                controller: widget.controller,
                obscureText: widget.isPassword ? _obscureText : false,
                keyboardType: widget.keyboardType,
                onTap: () {
                  setState(() {
                    _isTouched = true; // L'utilisateur a touché le champ
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
                      : _isTouched && (_errorMessage != null && _errorMessage!.isNotEmpty)
                          ? Icon(
                              Icons.error_outline,
                              color: Colors.red, // Point d'exclamation rouge
                            )
                          : null,
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
          // Affichage du message d'erreur sous le champ de texte si nécessaire
          if (_errorMessage != null && _errorMessage!.isNotEmpty && _isTouched)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red,  // Couleur du texte d'erreur
                  fontSize: 12,  // Taille du texte d'erreur
                ),
              ),
            ),
        ],
      ),
    );
  }
}
