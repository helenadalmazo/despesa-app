import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/constant/hero_tag.dart';
import 'package:despesa_app/screen/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  String _validateUsername(String value) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

  Future<void> _login(BuildContext context) async {
    if (!_formGlobalKey.currentState.validate()) {
      return;
    }

    String username = _usernameTextEditingController.text;
    String password = _passwordTextEditingController.text;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: HeroTag.welcome_text,
                child: Text(
                  'Bem vindo(a)',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Form(
                key: _formGlobalKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameTextEditingController,
                      validator: _validateUsername,
                      decoration: InputDecoration(
                        hintText: 'Usuário',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _passwordTextEditingController,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                      ),
                      obscureText: true,
                    ),
                  ],
                )
              ),
              SizedBox(
                height: 16,
              ),
              Hero(
                tag: HeroTag.login_button,
                child: TextButton(
                  onPressed: () => _login(context),
                  child: Text(
                    'ENTRAR'
                  ),
                ),
              )
            ]
          ),
        ),
      )
    );
  }
}
