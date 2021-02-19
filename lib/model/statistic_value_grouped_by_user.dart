import 'package:despesa_app/model/user.dart';

class StatisticValueGroupedByUser {
  final User user;
  final double value;

  StatisticValueGroupedByUser({
    this.user,
    this.value,
  });

  factory StatisticValueGroupedByUser.fromJson(Map<String, dynamic> json) {
    return StatisticValueGroupedByUser(
      user: User.fromJson(json["user"]),
      value: json["value"]
    );
  }
}