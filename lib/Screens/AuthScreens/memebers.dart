import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberSelectionPage extends StatefulWidget {
  @override
  _MemberSelectionPageState createState() => _MemberSelectionPageState();
}

class _MemberSelectionPageState extends State<MemberSelectionPage> {
  List<dynamic> selectedMembers = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false).fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sélectionner des artistes à suivre",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.25,
            letterSpacing: 0.50,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, selectedMembers); // Retourner la sélection
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFormField(
              controller: _searchController,
              onChanged: (query) {
                Provider.of<Products>(context, listen: false)
                    .filterMembers(query);
              },
              label: 'Rechercher',
              isPassword: false,
            ),
          ),
          Expanded(
            child: Consumer<Products>(
              builder: (context, productsProvider, child) {
                return ListView.builder(
                  itemCount: productsProvider.filteredMembers.length,
                  itemBuilder: (context, index) {
                    final member = productsProvider.filteredMembers[index];
                    final isSelected = selectedMembers
                        .any((m) => m['id'] == member['id']); // Vérification par ID

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          member["image_type"] == "normal"
                              ? "${AppConfig.baseUrl}${member['avatar'] ?? ''}"
                              : (member["avatar"] ?? ''),
                        ),
                      ),
                      title: Text(member['full_name'] ?? 'Nom Inconnu',
                          style: TextStyle(fontFamily: "Raleway")),
                      subtitle: Text(
                        'Rating: ${member['average_rating'] ?? 'N/A'} ⭐',
                        style: TextStyle(fontFamily: "Raleway"),
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedMembers.removeWhere(
                                (m) => m['id'] == member['id']);
                          } else {
                            selectedMembers.add({
                              'id': member['id'],
                              'full_name': member['full_name'],
                            });
                          }
                        });
                      },
                      tileColor: isSelected ? Colors.blue.shade100 : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
