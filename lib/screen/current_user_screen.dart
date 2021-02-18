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
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: _currentUser.getColor(),
                  child: Text(
                    _currentUser.getAcronym(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28
                    )
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Hero(
                  tag: "user_fullName_${_currentUser.id}",
                  child: Text(
                    _currentUser.fullName,
                    style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.white
                      )
                    )
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  _currentUser.username,
                  style: Theme.of(context).textTheme.subtitle1.merge(
                    TextStyle(
                      color: Colors.white
                    )
                  )
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            OutlineButton(
              onPressed: () => _settingScreen(context),
              borderSide: BorderSide(
                color: Colors.white,
              ),
              child: Text(
                'Configurações',
                style: TextStyle(
                  color: Colors.white
                ),
              )
            ),
            OutlineButton(
              onPressed: () => _logout(context),
              borderSide: BorderSide(
                color: Colors.white,
              ),
              child: Text(
                'Sair',
                style: TextStyle(
                  color: Colors.white
                ),
              )
            )
          ],
        ),
      ),
    );
  }

}