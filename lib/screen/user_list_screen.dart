import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:despesa_app/screen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class UserListScreen extends StatelessWidget {
  final Group group;

  final TextEditingController _fullNameTextEditingController = TextEditingController();

  UserListScreen({
    Key key,
    this.group,
  }) : super(key: key);

  void _userScreen(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserScreen(
          group: group,
          user: user
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text('Adicionar usuário'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16
            ),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Procurar por nome completo"
                ),
                controller: _fullNameTextEditingController
              ),
              suggestionsCallback: (String query) async {
                return await GroupRepository.instance.searchNewUser(group.id, query);
              },
              itemBuilder: (BuildContext context, User user) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: user.getColor(),
                    child: Text(
                      user.getAcronym(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                      )
                    ),
                  ),
                  title: Text(user.fullName),
                );
              },
              onSuggestionSelected: (User user) {
                _fullNameTextEditingController.text = user.fullName;
                _userScreen(context, user);
              },
              noItemsFoundBuilder: (BuildContext context) {
                return ListTile(
                  title: Text("Nenhum usuário encontrado"),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}