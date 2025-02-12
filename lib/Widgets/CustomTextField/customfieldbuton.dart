import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormFieldwithButton extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final String? defaultValue;
  final VoidCallback? onButtonPressed;
  final Color? buttonColor;
  final bool? isCommented;
  CustomTextFormFieldwithButton({
    super.key,
    required this.controller,
    required this.label,
    required this.isPassword,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
    this.defaultValue,
    this.onButtonPressed,
    this.buttonColor = const Color(0xFFFB98B7),
     this.isCommented = false,
  });

  @override
  State<CustomTextFormFieldwithButton> createState() => _CustomTextFormFieldwithButtonState();
}

class _CustomTextFormFieldwithButtonState extends State<CustomTextFormFieldwithButton> {
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
                side: const BorderSide(width: 1, color: Color(0xFF5C7CA4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onSaved: widget.onSaved,
                    controller: widget.controller,
                    obscureText: widget.isPassword ? _obscureText : false,
                    keyboardType: widget.keyboardType,
                    cursorColor: Colors.grey,
                    style: const TextStyle(fontFamily: 'Raleway'),
                    onTap: () {
                      setState(() {
                        _isTouched = true;
                      });
                    },
                    decoration: InputDecoration(
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
                if (widget.isPassword)
                  GestureDetector(
                    onTap: _togglePasswordVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                        _obscureText
                            ? "assets/Icons/eye-slash.svg"
                            : "assets/Icons/eye.svg",
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                if (widget.onButtonPressed != null)
                  GestureDetector(
                    onTap: widget.onButtonPressed,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: !(widget.isCommented!) ?  Color(0xFFFB98B7) : Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: !(widget.isCommented!) ? const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ) :const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
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
