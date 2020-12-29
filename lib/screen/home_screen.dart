import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/model/user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String fullName;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(32),
            child: Text(
              'Olá, $fullName',
              style: Theme.of(context).textTheme.headline5
            ),
          )

        ]
      )
    );
  }
}
