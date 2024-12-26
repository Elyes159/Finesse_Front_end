import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Importer le package flutter_svg

class VerificationMail extends StatefulWidget {
  const VerificationMail({super.key});

  @override
  State<VerificationMail> createState() => _VerificationMailState();
}

class _VerificationMailState extends State<VerificationMail> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/ArrowLeft.svg', // Le chemin vers l'icône SVG
            width: 24, // Ajuster la taille si nécessaire
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context); // Permet de revenir à la page précédente
          },
        ),
      ),
      body: ListView(
        children: [
          const Text(
            'Enter the passcode',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF111928),
              fontSize: 32,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(
            width: 343,
            height: 30,
            child: Text(
              'Enter the passcode sent to "email​".',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 48.83,
                  height: 56,
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      ),
                    ),
                  ),
                  child: TextField(
                    cursorColor: Colors.grey,
                    controller: _controllers[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFF111928),
                          width: 1.5,
                        ),
                      ),
                    ),
                    
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomButton(label: "Next", onTap: (){})
          ),
        ],
      ),
    );
  }
}
