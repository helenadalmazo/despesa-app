import 'package:despesa_app/model/user.dart';
import 'package:flutter/material.dart';

class UserCircleAvatar extends StatelessWidget {

  final User user;
  final int size;

  const UserCircleAvatar({
    Key key,
    @required this.user,
    this.size = 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20 * size.toDouble(),
      backgroundColor: user.getColor(),
      child: Text(
        user.getAcronym(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 14 * size.toDouble()
        )
      ),
    );
  }
}