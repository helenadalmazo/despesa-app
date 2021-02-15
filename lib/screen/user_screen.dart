import 'package:despesa_app/model/group_user_role.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final int groupId;
  final User user;

  const UserScreen({
    Key key,
    @required this.groupId,
    @required this.user
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  GroupUserRole _groupUserRole = GroupUserRole.USER;

  Future<void> _addUser(BuildContext context) async {
    await GroupRepository.instance.addUser(
      widget.groupId,
      widget.user.id,
      _groupUserRole.toString().split(".").last
    );
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text('Adicionar usuário'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24
              ),
              child: Text(
                widget.user.fullName,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            RadioListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Administrador',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'Pode inserir e remover usuários, adicionar, editar e excluir despesas.',
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              ),
              value: GroupUserRole.ADMIN,
              groupValue: _groupUserRole,
              onChanged: (GroupUserRole role) {
                setState(() {
                  _groupUserRole = role;
                });
              },
            ),
            RadioListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuário',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'Pode somente visualizar usuários e despesas.',
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              ),
              value: GroupUserRole.USER,
              groupValue: _groupUserRole,
              onChanged: (GroupUserRole role) {
                setState(() {
                  _groupUserRole = role;
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addUser(context),
        child: Icon(Icons.check),
      ),
    );
  }
}