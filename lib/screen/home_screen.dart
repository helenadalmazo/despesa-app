import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/clipper/isosceles_trapezoid_clipper.dart';
import 'package:despesa_app/model/group_model.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:despesa_app/screen/group_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String fullName;
  List<Group> groupList = [];
  bool loading = true;

  final TextEditingController _groupNameTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    getGroupList();

    setState(() {
      loading = false;
    });
  }

  void getCurrentUser() async {
    User currentUser = await Authentication.instance.currentUser;
    setState(() {
      fullName = currentUser.fullName;
    });
  }

  void getGroupList() async {
    List<Group> list = await GroupRepository.instance.list();
    setState(() {
      groupList = list;
    });
  }

  String _validateGroupName(String value) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

  void _saveGroup(String name) async {
    Group save = await GroupRepository.instance.save(name);
    setState(() {
      groupList.add(save);
    });
  }

  void _updateGroup(String name, int id,  int index) async {
    final String groupName = _groupNameTextEditingController.text;
    Group update = await GroupRepository.instance.update(id, groupName);
    setState(() {
      groupList[index] = update;
    });
  }

  void _deleteGroup(int id, int index) async {
    Map<String, dynamic> delete = await GroupRepository.instance.delete(id);
    setState(() {
      groupList.removeAt(index);
    });
  }

  void _showGroupModalBottomSheet(BuildContext context, Function function, [Group group, int index]) {
    _groupNameTextEditingController.text = group == null ? "" : group.name;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    TextFormField(
                      controller: _groupNameTextEditingController,
                      validator: _validateGroupName,
                      decoration: InputDecoration(
                        hintText: 'Novo grupo',
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          function(_groupNameTextEditingController.text, group == null ? null : group.id, index);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Salvar'
                        )
                      ),
                    )
                  ],
                )
              ],
            )
          ),
        );
      }
    );
  }

  void _showDeleteGroupDialog(BuildContext context, Group group, int index) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover grupo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você quer realmente remover esse grupo?'),
                Text('Essa ação não pode ser desfeita.'),
              ],
            ),
          ),
          actions: <Widget> [
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                _deleteGroup(group.id, index);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showGroupOptionsModalBottomSheet(BuildContext context, Group group, int index) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _showGroupModalBottomSheet(context, _updateGroup, group, index);
              },
              leading: Icon(Icons.edit),
              title: Text('Editar grupo'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _showDeleteGroupDialog(context, group, index);
              },
              leading: Icon(Icons.delete),
              title: Text('Remover grupo'),
            )
          ],
        );
      }
    );
  }

  void _groupScreen(BuildContext context, int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GroupScreen(id: id)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
            ),
            child: Text(
              'Olá, $fullName',
              style: Theme.of(context).textTheme.headline5
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: IsoscelesTrapezoidClipper(),
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    child: FloatingActionButton(
                      onPressed: () => _showGroupModalBottomSheet(context, _saveGroup),
                      child: Icon(
                        Icons.add
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var index = 0; index < groupList.length; index++)
            InkWell(
              onLongPress: () => _showGroupOptionsModalBottomSheet(context, groupList[index], index),
              onTap: () => _groupScreen(context, groupList[index].id),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16
                ),
                child: Text(
                  groupList[index].name,
                  style: Theme.of(context).textTheme.headline6
                )
              ),
            ),
        ]
      )
    );
  }
}
