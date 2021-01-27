import 'package:despesa_app/model/expense_item.dart';

class Expense {
  final int id;
  final int groupId;
  final String name;
  final List<ExpenseItem> items;

  Expense({
    this.id,
    this.groupId,
    this.name,
    this.items
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonItems = json['items'];

    return Expense(
      id: json['id'],
      groupId: json['group_id'],
      name: json['name'],
      items: jsonItems.map((dynamic item) => ExpenseItem.fromJson(item)).toList(),
    );
  }
}
