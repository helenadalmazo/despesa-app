import 'package:flutter/material.dart';

class User {
  final int id;
  final String username;
  final String fullName;

  User({
    this.id,
    this.username,
    this.fullName
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        fullName = json["full_name"];

  String getAcronym() {
    List<String> names = this.fullName.toUpperCase().split(" ");

    String firstName = names.first;
    if (names.length < 2) {
      return firstName[0];
    }

    String lastName = names.last;
    return firstName[0] + lastName[0];
  }

  Color getColor() {
    int firstLetterCodeUnit = this.fullName
        .toUpperCase()
        .split("")
        .map((value) => value.codeUnitAt(0))
        .reduce((value, element) => value + element) - 64;

    double slit = firstLetterCodeUnit / Colors.primaries.length;

    int index = firstLetterCodeUnit - (Colors.primaries.length * slit.toInt());

    return Colors.primaries[index];
  }
}