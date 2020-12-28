import 'package:despesa_app/screen/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {

  void _loginScreen(BuildContext context) {
    
  }

  void _signUpScreen(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 32
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem vindo(a)',
                style: Theme.of(context).textTheme.headline4,
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
                  TextButton(
                    onPressed: () => _loginScreen(context),
                    child: Text(
                      'ENTRAR'
                    ),
                  ),
                  TextButton(
                    onPressed: () => _signUpScreen(context),
                    child: Text(
                      'REGISTRAR'
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}