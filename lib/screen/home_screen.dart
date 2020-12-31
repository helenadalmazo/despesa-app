import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/clipper/isosceles_trapezoid_clipper.dart';
import 'package:despesa_app/model/group_model.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/repository/group_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String fullName;
  List<Group> groupList = [];
  bool loading = true;

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
                      onPressed: null,
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
              onTap: null,
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
