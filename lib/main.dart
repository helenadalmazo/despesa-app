import 'package:despesa_app/screen/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(DespesaApp());

class DespesaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,

        primaryColor: Color.fromRGBO(68, 119, 166, 1),
        primaryColorLight: Color.fromRGBO(118, 166, 216, 1),
        primaryColorDark: Color.fromRGBO(0, 76, 119, 1),

        accentColor: Color.fromRGBO(68, 70, 166, 1),
      ),
      home: WelcomeScreen(),
    );
  }
}
