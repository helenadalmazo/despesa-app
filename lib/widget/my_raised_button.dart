import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;

  const MyRaisedButton({
    Key key,
    @required this.onPressed,
    @required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white
        )
      ),
      color: Theme.of(context).accentColor,
    );
  }
}