import 'package:despesa_app/constant/hero_tag.dart';
import 'package:despesa_app/screen/login_screen.dart';
import 'package:despesa_app/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {

  void _loginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen()
      )
    );
  }

  void _signUpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SignUpScreen()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 32
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: HeroTag.welcome_text,
              child: Text(
                'Bem vindo(a)',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Pitch black malt barleywine specific gravity wort chiller balthazar pitch.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hero(
                  tag: HeroTag.login_button,
                  child: TextButton(
                    onPressed: () => _loginScreen(context),
                    child: Text(
                      'ENTRAR'
                    ),
                  ),
                ),
                Hero(
                  tag: HeroTag.sign_up_button,
                  child: TextButton(
                    onPressed: () => _signUpScreen(context),
                    child: Text(
                      'REGISTRAR'
                    ),
                  )
                )
              ],
            )
          ],
        ),
      )
    );
  }
}