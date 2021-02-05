import 'package:despesa_app/model/expense_item.dart';

class Expense {
  final int id;
  final int createdBy;
  final String dateCreated;
  final int groupId;
  final String name;
  final double value;
  final String description;
  final List<ExpenseItem> items;

  Expense({
    this.id,
    this.createdBy,
    this.dateCreated,
    this.groupId,
    this.name,
    this.value,
    this.description,
    this.items
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonItems = json['items'];

    return Expense(
      id: json['id'],
      createdBy: json['created_by'],
      dateCreated: json['date_created'],
      groupId: json['group_id'],
      name: json['name'],
      value: json['value'],
      description: json['description'],
      items: jsonItems.map((dynamic item) => ExpenseItem.fromJson(item)).toList(),
    );
  }
}
