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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      fullName: json["full_name"]
    );
  }

  String getFirstName() {
    return this.fullName.split(" ").first;
  }

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
    String unique = this.fullName + this.username;
    int firstLetterCodeUnit = unique
        .split("")
        .map((value) => value.codeUnitAt(0))
        .reduce((value, element) => value + element);

    double slit = firstLetterCodeUnit / Colors.primaries.length;

    int index = firstLetterCodeUnit - (Colors.primaries.length * slit.toInt());

    return Colors.primaries[index];
  }
}