import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdownFormField<K, V> extends StatefulWidget {
  final List<Map<K, V>> options; // Liste des options sous forme de Map<K, V>
  final String label; // Label du champ
  final K? selectedKey; // Clé sélectionnée par défaut
  final ValueChanged<K?>? onChanged; // Callback pour le changement de clé
  final FormFieldValidator<K>? validator; // Validation
  final FormFieldSetter<K>? onSaved; // Sauvegarde

  const CustomDropdownFormField({
    super.key,
    required this.options,
    required this.label,
    this.selectedKey,
    this.onChanged,
    this.validator,
    this.onSaved,
  });

  @override
  State<CustomDropdownFormField<K, V>> createState() =>
      _CustomDropdownFormFieldState<K, V>();
}

class _CustomDropdownFormFieldState<K, V>
    extends State<CustomDropdownFormField<K, V>> {
  K? _selectedKey;
  String? _errorMessage;
  bool _isTouched = false;

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.selectedKey;
  }

  void _onChanged(K? newKey) {
    setState(() {
      _isTouched = true;
      _selectedKey = newKey;
      _errorMessage = widget.validator?.call(newKey);
    });
    if (widget.onChanged != null) {
      widget.onChanged!(newKey);
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF5C7CA4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: DropdownButtonFormField<K>(
              value: _selectedKey,
              onChanged: _onChanged,
              onSaved: widget.onSaved,
              validator: (value) {
                final error = widget.validator?.call(value);
                if (mounted) {
                  setState(() {
                    _errorMessage = error;
                  });
                }
                return error;
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
              icon: Transform.translate(
                offset: const Offset(0, -8),
                child: SvgPicture.asset(
                  "assets/Icons/down.svg",
                  height: 24,
                  width: 24,
                ),
              ),
              // Personnalisation du menu déroulant
              style: const TextStyle(
                fontFamily: 'Raleway',
                color: Color(0xFF3E536E),
              ),
              items: widget.options
                  .map(
                    (option) => DropdownMenuItem<K>(
                      value: option.keys.first,
                      child: Text(
                        option.values.first.toString(),
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: Color(0xFF3E536E),
                        ),
                      ),
                    ),
                  )
                  .toList(),
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
