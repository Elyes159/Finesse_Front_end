import 'package:finesse_frontend/Provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomDropdownFormField<K, V> extends StatefulWidget {
  final List<Map<K, V>> options; 
  final String label; 
  final K? selectedKey;
  final String? selectedValue; 
  final ValueChanged<K?>? onChanged; 
  final FormFieldValidator<K>? validator; 
  final FormFieldSetter<K>? onSaved;
  final bool? isButton;
  final bool? imageMenu;
  final bool? image;
  final String? pathImageHorsmenu;
  final List<Color>? colors; // Liste des couleurs
  final List<String>? pathImagesForsmenu;
  final VoidCallback? onTap;

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
    this.colors, // Liste des couleurs
    this.pathImageHorsmenu,
    this.pathImagesForsmenu,
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
        widget.options.any((option) => option.keys.first == widget.selectedKey)) {
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
              borderRadius: BorderRadius.circular(2),
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
                    : Colors.black,
                width: 1,
              ),
            ),
            child: widget.isButton == true
                ? GestureDetector(
                    onTap: widget.onTap,
                    child: Row(
                      children: [
                        if (widget.image == true)
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(0),
                              image: DecorationImage(
                                image: AssetImage(widget.pathImageHorsmenu!),
                                fit: BoxFit.cover,
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
                      ],
                    ),
                  )
                : Row(
                    children: [
                      if (widget.image == true)
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.pathImageHorsmenu!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.zero,
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
                          items: widget.options.asMap().entries.map(
                            (entry) {
                              int index = entry.key;
                              Map<K, V> option = entry.value;

                              // Utilisation de la liste des couleurs pour chaque élément
                              Color itemColor = widget.colors != null &&
                                      widget.colors!.isNotEmpty
                                  ? widget.colors![index % widget.colors!.length]
                                  : (theme ? Colors.white : Colors.black);

                              return DropdownMenuItem<K>(
                                value: option.keys.first,
                                child: Row(
                                  children: [
                                    if (widget.imageMenu == true &&
                                        widget.pathImagesForsmenu != null)
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: itemColor,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                    const SizedBox(width: 8),
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
                              );
                            },
                          ).toList(),
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

