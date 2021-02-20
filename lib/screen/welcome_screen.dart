import 'package:despesa_app/constant/hero_tag.dart';
import 'package:despesa_app/screen/login_screen.dart';
import 'package:despesa_app/screen/sign_up_screen.dart';
import 'package:despesa_app/widget/my_raised_button.dart';
import 'package:flutter/cupertino.dart';
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
      backgroundColor: Theme.of(context).primaryColor,
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
                style: Theme.of(context).textTheme.headline4.merge(
                  TextStyle(
                    color: Colors.white,
                  )
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Pitch black malt barleywine specific gravity wort chiller balthazar pitch.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.80)
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: Theme.of(context).buttonTheme.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Hero(
                    tag: HeroTag.login_button,
                    child: MyRaisedButton(
                      onPressed: () => _loginScreen(context),
                      text: "ENTRAR",
                    ),
                  ),
                  Hero(
                    tag: HeroTag.sign_up_button,
                    child: MyRaisedButton(
                      onPressed: () => _signUpScreen(context),
                      text: "REGISTRAR"
                    )
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}