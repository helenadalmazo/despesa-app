import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/constant/hero_tag.dart';
import 'package:despesa_app/screen/home_screen.dart';
import 'package:despesa_app/utils/scaffold_utils.dart';
import 'package:despesa_app/utils/text_form_field_validator.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {

  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();

  final TextEditingController _fullNameTextEditingController = TextEditingController();
  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    if (!_formGlobalKey.currentState.validate()) {
      return;
    }

    final String fullName = _fullNameTextEditingController.text;
    final String username = _usernameTextEditingController.text;
    final String password = _passwordTextEditingController.text;
    final String confirmPassword = _confirmPasswordTextEditingController.text;

    final Map<String, dynamic> signUpResult = await Authentication.instance.signUp(
      fullName, username, password, confirmPassword
    );

    if (signUpResult['success']) {
      final Map<String, dynamic> loginResult = await Authentication.instance.login(
          username, password
      );

      if (loginResult['success']) {
        _homeScreen(context);
      } else {
        ScaffoldUtils.showSnackBar(context, loginResult['message']);
      }
    } else {
      ScaffoldUtils.showSnackBar(context, signUpResult['message']);
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
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Center(
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
                              controller: _fullNameTextEditingController,
                              validator: TextFormFieldValidator.validateMandatory,
                              decoration: InputDecoration(
                                hintText: 'Nome completo',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _usernameTextEditingController,
                              validator: TextFormFieldValidator.validateMandatory,
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
                              validator: TextFormFieldValidator.validateMandatory,
                              decoration: InputDecoration(
                                hintText: 'Senha',
                              ),
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _confirmPasswordTextEditingController,
                              validator: TextFormFieldValidator.validateMandatory,
                              decoration: InputDecoration(
                                hintText: 'Confirmar senha',
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
                        tag: HeroTag.sign_up_button,
                        child: TextButton(
                          onPressed: () => _login(context),
                          child: Text(
                            'REGISTRAR'
                          ),
                        ),
                      )
                    ]
                  ),
                ),
              ),
            )
          );
        },
      ),
    );
  }
}
