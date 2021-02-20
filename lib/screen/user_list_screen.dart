import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:despesa_app/screen/user_screen.dart';
import 'package:despesa_app/widget/user_circle_avatar.dart';
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
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Selecionar usuário'),
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
                  hintText: "Procurar por nome completo",
                  suffixIcon: Icon(Icons.search)
                ),
                controller: _fullNameTextEditingController,
              ),
              suggestionsCallback: (String query) async {
                return await GroupRepository.instance.searchNewUser(group.id, query);
              },
              itemBuilder: (BuildContext context, User user) {
                return ListTile(
                  leading: UserCircleAvatar(
                    user: user
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