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
      ),
      home: WelcomeScreen(),
    );
  }
}
