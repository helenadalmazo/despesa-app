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

  void _saveGroup() async {
    final String groupName = _groupNameTextEditingController.text;
    Group save = await GroupRepository.instance.save(groupName);
    setState(() {
      groupList.add(save);
    });
  }

  void _showNewGroupModalBottomSheet(BuildContext context) {
    _groupNameTextEditingController.text = "";

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
                          _saveGroup();
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
                      onPressed: () => _showNewGroupModalBottomSheet(context),
                      child: Icon(
                        Icons.add
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var group in groupList)
            InkWell(
              onTap: () => _groupScreen(context, group.id),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16
                ),
                child: Text(
                  group.name,
                  style: Theme.of(context).textTheme.headline6
                )
              ),
            ),
        ]
      )
    );
  }
}
