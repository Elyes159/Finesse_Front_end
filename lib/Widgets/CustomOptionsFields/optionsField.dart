import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomDropdownFormField<K, V> extends StatefulWidget {
  final List<Map<K, V>> options; // Liste des options sous forme de Map<K, V>
  final String label; // Label du champ
  final K? selectedKey;
  final String? selectedValue; // Clé sélectionnée par défaut
  final ValueChanged<K?>? onChanged; // Callback pour le changement de clé
  final FormFieldValidator<K>? validator; // Validation
  final FormFieldSetter<K>? onSaved;
  final bool? isButton;
  final bool? imageMenu;
  final bool? image;
  final String? pathImageHorsmenu;
  final String? pathImageForsmenu;
  final VoidCallback? onTap; // Sauvegarde

  const CustomDropdownFormField({
    super.key,
    required this.options,
    required this.label,
    this.selectedKey,
    this.selectedValue,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.isButton = false,
    this.onTap,
    this.imageMenu = false,
    this.image = false,
    this.pathImageHorsmenu,
    this.pathImageForsmenu, // Défaut à false pour un DropdownButton
  });

  @override
  State<CustomDropdownFormField<K, V>> createState() =>
      _CustomDropdownFormFieldState<K, V>();
}

class _CustomDropdownFormFieldState<K, V>
    extends State<CustomDropdownFormField<K, V>> {
  K? _selectedKey;
  String? _selectedValue;
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
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: theme
                  ? [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
              border: Border.all(
                color: theme
                    ? Color.fromARGB(255, 249, 217, 144)
                    : Color(0xFF5C7CA4),
                width: 1,
              ),
            ),
            child: widget.isButton == true
                ? Row(
                    children: [
                      if (widget.image == true)
                        Container(
                          width:
                              50, // Augmente la largeur pour agrandir l'image
                          height:
                              50, // Assure-toi que la hauteur est identique à la largeur pour le carré
                          decoration: BoxDecoration(
                            shape: BoxShape
                                .rectangle, // Pour obtenir une forme carrée
                            borderRadius: BorderRadius.circular(
                                0), // Pour arrondir les coins si tu veux
                            image: DecorationImage(
                              image: AssetImage(widget.pathImageHorsmenu!),
                              fit: BoxFit
                                  .cover, // Assure-toi que l'image remplit l'espace
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: theme ? Colors.white : Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme
                                  ? Color.fromARGB(255, 249, 217, 144)
                                  : Color(0xFFFB98B7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            )),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      if (widget.image == true)
                        Container(
                          width: 50, // Définir la largeur du carré
                          height:
                              50, // Définir la hauteur du carré (doit être égal à la largeur pour un carré)
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.pathImageHorsmenu!),
                              fit: BoxFit
                                  .cover, // Pour ajuster l'image à l'intérieur du carré
                            ),
                            borderRadius: BorderRadius
                                .zero, // Pas de bordure arrondie, c'est un carré
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<K>(
                          borderRadius: BorderRadius.circular(16),
                          isExpanded: true,
                          value: widget.options.any(
                                  (option) => option.keys.first == _selectedKey)
                              ? _selectedKey
                              : null,
                          onChanged: _onChanged,
                          icon: const SizedBox.shrink(),
                          alignment: AlignmentDirectional.centerEnd,
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: theme ? Colors.white : Colors.black,
                          ),
                          underline: const SizedBox.shrink(),
                          items: widget.options
                              .map(
                                (option) => DropdownMenuItem<K>(
                                  value: option.keys.first,
                                  child: Row(
                                    children: [
                                      if (widget.imageMenu == true)
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                            widget.pathImageForsmenu!,
                                          ),
                                        ),
                                      Expanded(
                                        child: Text(
                                          option.values.first.toString(),
                                          style: TextStyle(
                                            color: theme
                                                ? Colors.white
                                                : Colors.black,
                                            fontFamily: 'Raleway',
                                          ),
                                        ),
                                      ),
                                    ],
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
                                      : widget.options.any((option) =>
                                              option.keys.first == _selectedKey)
                                          ? widget.options
                                              .firstWhere(
                                                (option) =>
                                                    option.keys.first ==
                                                    _selectedKey,
                                                orElse: () => {},
                                              )
                                              .values
                                              .toString()
                                          : 'please select a category',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
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
