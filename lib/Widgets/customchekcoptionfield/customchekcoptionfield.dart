import 'package:flutter/material.dart';

class CustomCheckboxFormField extends StatefulWidget {
  final String label; // Étiquette du champ
  final bool initialValue; // Valeur initiale
  final ValueChanged<bool>? onChanged; // Callback pour le changement d'état
  final FormFieldValidator<bool>? validator; // Validation
  final FormFieldSetter<bool>? onSaved; // Sauvegarde

  const CustomCheckboxFormField({
    super.key,
    required this.label,
    this.initialValue = false, // Par défaut, la case est décochée
    this.onChanged,
    this.validator,
    this.onSaved,
  });

  @override
  State<CustomCheckboxFormField> createState() =>
      _CustomCheckboxFormFieldState();
}

class _CustomCheckboxFormFieldState extends State<CustomCheckboxFormField> {
 bool _value = false;
  String? _errorMessage; // Message d'erreur
  bool _isTouched = false; // Indique si le champ a été touché

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue; // Initialiser la valeur par défaut
  }

  void _onChanged(bool newValue) {
    setState(() {
      _isTouched = true; // Champ touché
      _value = newValue;
      _errorMessage = widget.validator?.call(newValue); // Validation
    });
    if (widget.onChanged != null) {
      widget.onChanged!(newValue);
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF5C7CA4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Color(0xFF3E536E),
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Checkbox(
                  hoverColor: const Color(0xFFC9CACC),
                  focusColor: const Color(0xFFC9CACC),
                  value: _value,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      _onChanged(newValue);
                    }
                  },
                  activeColor: const Color(0xFF5C7CA4),
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
