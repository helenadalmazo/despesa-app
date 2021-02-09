import 'package:despesa_app/model/user.dart';

class ExpenseItem {
  final int id;
  final User user;
  final double value;

  ExpenseItem({
    this.id,
    this.user,
    this.value
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      id: json["id"],
      user: User.fromJson(json["user"]),
      value: json["value"]
    );
  }
}
