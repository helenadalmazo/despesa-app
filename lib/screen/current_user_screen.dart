import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/screen/welcome_screen.dart';
import 'package:flutter/material.dart';

class CurrentUserScreen extends StatelessWidget {
  final User _currentUser = Authentication.instance.currentUser;

  void _settingScreen(BuildContext context) {

  }

  void _logout(BuildContext context) {
    Authentication.instance.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeScreen()
      ),
      (Route<dynamic> route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _currentUser.getColor(),
              child: Text(
                _currentUser.getAcronym(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14
                )
              ),
            ),
            Hero(
              tag: "user_fullName_${_currentUser.id}",
              child: Text(
                _currentUser.fullName,
                style: Theme.of(context).textTheme.headline6
              ),
            ),
            Text(
                _currentUser.username,
                style: Theme.of(context).textTheme.subtitle1
            ),
            TextButton(
                onPressed: () => _settingScreen(context),
                child: Text('Configurações')
            ),
            TextButton(
                onPressed: () => _logout(context),
                child: Text('Sair')
            )
          ],
        ),
      ),
    );
  }

}