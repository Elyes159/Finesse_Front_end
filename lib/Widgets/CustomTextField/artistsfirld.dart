import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ArtistsField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final bool? enabled;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final String? defaultValue;
  final ValueChanged<String>? onChanged; // ✅ Nouveau paramètre

  const ArtistsField({
    super.key,
    required this.controller,
    required this.label,
    required this.isPassword,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
    this.defaultValue,
    this.enabled,
    this.onChanged, // ✅ Ajout de onChanged
  });

  @override
  State<ArtistsField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<ArtistsField> {
  bool _obscureText = true;
  String? _errorMessage;
  bool _isTouched = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {
        _errorMessage = widget.validator?.call(widget.controller.text);
      });
    }

    // ✅ Appeler onChanged si défini
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  @override
  void initState() {
    super.initState();
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
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
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
                side: BorderSide(
                  width: 1,
                  color: theme ? Color.fromARGB(255, 249, 217, 144) : Colors.grey,
                ),
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
              onChanged: (value) => _onTextChanged(), // ✅ Ajout de onChanged
              onTap: () {
                setState(() {
                  _isTouched = true;
                });
              },
              decoration: InputDecoration(
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: SvgPicture.asset(
                          _obscureText
                              ? "assets/Icons/eye-slash.svg"
                              : "assets/Icons/eye.svg",
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
