import 'package:despesa_app/constant/hero_tag.dart';
import 'package:despesa_app/exception/ApiException.dart';
import 'package:despesa_app/screen/home_screen.dart';
import 'package:despesa_app/service/authentication_service.dart';
import 'package:despesa_app/utils/scaffold_utils.dart';
import 'package:despesa_app/utils/text_form_field_validator.dart';
import 'package:despesa_app/widget/accent_color_raised_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    if (!_formGlobalKey.currentState.validate()) {
      return;
    }

    final String username = _usernameTextEditingController.text;
    final String password = _passwordTextEditingController.text;

    try {
      await AuthenticationService.instance.login(
        username, password
      );
      _homeScreen(context);
    } on ApiException catch(apiException) {
      ScaffoldUtils.showSnackBar(context, apiException.message);
    }
  }

  void _homeScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen()
      ),
      (Route<dynamic> route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: HeroTag.welcome_text,
                      child: Text(
                        'Bem vindo(a)',
                        style: Theme.of(context).textTheme.headline4.merge(
                          TextStyle(
                            color: Theme.of(context).primaryColor
                          )
                        ),
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
                              validator: TextFormFieldValidator.validateMandatory,
                              decoration: InputDecoration(
                                labelText: 'Usuário',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _passwordTextEditingController,
                              validator: TextFormFieldValidator.validateMandatory,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                              ),
                              obscureText: true,
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: Theme.of(context).buttonTheme.height,
                      child: Hero(
                        tag: HeroTag.login_button,
                        child: AccentColorRaisedButton(
                          onPressed: () => _login(context),
                          text: "ENTRAR"
                        ),
                      ),
                    )
                  ]
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
