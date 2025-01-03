import 'dart:io';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/Stories.dart';
import 'package:finesse_frontend/Widgets/Navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String? parameter;
  const HomeScreen({Key? key , required this.parameter}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if(widget.parameter == "normal") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AuthService>(context, listen: false).loadUserData();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AuthService>(context, listen: false).loadUserGoogleData();
      });
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mettre à jour l'index sélectionné
    });
  }
   XFile? _image;
   Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }
    final storage = FlutterSecureStorage();
int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).currentUser!;   
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20.0,left:20, right:10),
            child: SafeArea(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: (user.avatar != "" && user.avatar != null)
                            ? NetworkImage(widget.parameter == "normal"
                                ? "${AppConfig.baseUrl}${user.avatar}"
                                : user.avatar!
                                )
                            : AssetImage('assets/images/user.png') as ImageProvider, // Image locale si avatar est null
                        backgroundColor: Colors.transparent,
                        child: user.avatar == null
                            ? const CircularProgressIndicator()
                            : null,
                      ),
                    ),
                     const SizedBox(width: 14), // Espacement entre l'avatar et le texte
                    Text(
                      'Hello, ${user.fullName.split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Raleway',
                      ),
                    ),
                  ],
                ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      print("heeeey ${user.hasStory}");
                    },
                    child: SvgPicture.asset("assets/Icons/heartt.svg",height: 18,width: 18,)),
                  SizedBox(width: 20,),
                  SvgPicture.asset("assets/Icons/favv.svg",),
                ],
               )
              ],
            ),
            ),
          ),
          SizedBox(height: 28,),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 10),
            child: Container(
              alignment: Alignment.topLeft, // Place le contenu en haut à gauche
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Consumer<Stories>(
                          builder: (context, stories, child) {
                            bool hasStory = stories.hasStory;

                            return Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: hasStory
                                    ? Border.all(color: Colors.blue, width: 2) // Bordure bleue si hasStory est true
                                    : null, 
                              ),
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: (user.avatar != "" && user.avatar != null)
                                    ? NetworkImage(widget.parameter == "normal"
                                        ? "${AppConfig.baseUrl}${user.avatar}"
                                        : user.avatar!)
                                    : AssetImage('assets/images/user.png') as ImageProvider,
                                backgroundColor: Colors.transparent,
                                child: user.avatar == null
                                    ?  Container()
                                    : null,
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await _pickImage();
                              if (_image != null) {
                                try {
                                  await Provider.of<Stories>(context, listen: false).createStory(
                                    userId: await storage.read(key: 'user_id'),
                                    storyImage: _image,
                                  );
                                  print("Story créée avec succès !");
                                } catch (e) {
                                  print("Erreur lors de la création de la story : $e");
                                }
                              } else {
                                print("Aucune image sélectionnée. Veuillez en choisir une.");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Veuillez sélectionner une image pour créer une story."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Colors.blue, 
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2), // Bordure blanche
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 12, 
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
