import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LetzGo extends StatefulWidget {
  final String parameter;
  const LetzGo({Key? key , required this.parameter}) : super(key: key);

  @override
  State<LetzGo> createState() => _LetzGoState();
}

class _LetzGoState extends State<LetzGo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  bool _isCheckedPrivacy = false;
  bool _isCheckedSend = false;
  String? _usernameError;
   bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/ArrowLeft.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Let’s go! ⚡️',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 36,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w800,
                height: 1.22,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose a username and enter your\ntelephone number',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                height: 1.50,
                letterSpacing: 0.15,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              controller: _usernameController,
              label: "Username",
              isPassword: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  setState(() {
                    _usernameError = 'Username is required';
                  });
                  return null;
                }
                if (value.length < 3) {
                  setState(() {
                     _usernameError = 'username must be longer than 3';
                  });
                  
                  return null;
                }
                setState(() {
                  _usernameError = null;
                });
                
                return null;
              },
            ),
            if (_usernameError != null)
              
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(
                    _usernameError!.contains("UNIQUE") ? "Existing username" : _usernameError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                 ),
              

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: const Color(0xFFFFDEC3),
                  value: _isCheckedPrivacy,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCheckedPrivacy = value ?? false;
                      if(_isCheckedPrivacy == true){
                        _usernameError = null;
                      }
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'I have read and accept ',
                      style: const TextStyle(
                        color: Color(0xFF111928),
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: 'Finesse Terms of Use',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Finesse Terms of Use clicked');
                            },
                        ),
                        const TextSpan(text: ', '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Privacy Policy clicked');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: const Color(0xFFFFDEC3),
                  value: _isCheckedSend,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCheckedSend = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    '(Optional) send me emails with updates, tips and special offers from Finesse',
                    style: TextStyle(
                      color: Color(0xFF111928),
                      fontSize: 14,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            CustomButton(
               textColor: _isLoading ? Color(0xFF111928) : Colors.white,
                  buttonColor: _isLoading? Color(0xFFE5E7EB) : Color(0xFFFB98B7),
              label: _isLoading? "Loading...": "Let’s go! ⚡️",
              onTap: _isLoading?(){}: _usernameError !=null ? (){}: () async {
                setState(() {
                  _isLoading = true;
                });
                if (_formKey.currentState!.validate()) {
                  try {
                    if(widget.parameter=="normal") {
                      await Provider.of<AuthService>(context, listen: false).createUsername(
                      username: _usernameController.text,
                      isPolicy: _isCheckedPrivacy,
                      isMail: _isCheckedSend,
                      userId: Provider.of<AuthService>(context, listen: false).userId,
                    );
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                        (Route<dynamic> route) => false, 
                      );
                    }else if(widget.parameter=="google"){
                      await Provider.of<AuthService>(context, listen: false).createUsernameGoogle(
                      username: _usernameController.text,
                      isPolicy: _isCheckedPrivacy,
                      isMail: _isCheckedSend,
                      userId: Provider.of<AuthService>(context, listen: false).userId,
                    );
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                        (Route<dynamic> route) => false, 
                      );
                    }else if(widget.parameter=="facebook"){
                         await Provider.of<AuthService>(context, listen: false).createUsernameFacebook(
                      username: _usernameController.text,
                      isPolicy: _isCheckedPrivacy,
                      isMail: _isCheckedSend,
                      userId: Provider.of<AuthService>(context, listen: false).userId,
                    );
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                        (Route<dynamic> route) => false, 
                      );
                    }
                      
                    setState(() {
                      _usernameError = null;
                    });
                  } catch (e) {
                    setState(() {
                      _usernameError = e.toString();
                    });
                  }
                }
                 setState(() {
                  _isLoading = false;
                });
              },
            ),

          ],
        ),
      ),
    );
  }
}