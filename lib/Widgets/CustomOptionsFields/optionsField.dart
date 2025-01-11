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
    if (widget.selectedKey != null &&
        widget.options
            .any((option) => option.keys.first == widget.selectedKey)) {
      _selectedKey = widget.selectedKey;
    } else {
      _selectedKey = null;
    }
  }

  void _onChanged(K? newKey) {
    setState(() {
      _isTouched = true;
      _selectedKey = newKey;
      _errorMessage = widget.validator?.call(newKey);
    });
    widget.onChanged?.call(newKey);
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
            child: DropdownButton<K>(
              isExpanded: true,
              value: widget.options
                      .any((option) => option.keys.first == _selectedKey)
                  ? _selectedKey
                  : null,
              onChanged: _onChanged,
              icon: SvgPicture.asset(
                "assets/Icons/down.svg",
                height: 24,
                width: 24,
              ),
              alignment: AlignmentDirectional.centerEnd,
              style: const TextStyle(
                fontFamily: 'Raleway',
                color: Color(0xFF3E536E),
              ),
              underline: const SizedBox.shrink(),
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
              hint: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedKey == null
                          ? widget.label
                          : widget.options.any(
                                  (option) => option.keys.first == _selectedKey)
                              ? widget.options
                                  .firstWhere(
                                    (option) =>
                                        option.keys.first == _selectedKey,
                                    orElse: () => {},
                                  )
                                  .values
                                  .toString()
                              : 'please select a category', // Message alternatif
                      style: const TextStyle(
                        color: Color(0xFF3E536E),
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
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
