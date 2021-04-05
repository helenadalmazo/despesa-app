import 'package:despesa_app/model/expense_category.dart';
import 'package:despesa_app/model/expense_item.dart';
import 'package:despesa_app/model/user.dart';

class Expense {
  final int id;
  final User createdBy;
  final String dateCreated;
  final String name;
  final ExpenseCategory category;
  final double value;
  final String description;
  final List<ExpenseItem> items;

  Expense({
    this.id,
    this.createdBy,
    this.dateCreated,
    this.name,
    this.category,
    this.value,
    this.description,
    this.items
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonItems = json["items"];

    return Expense(
      id: json["id"],
      createdBy: User.fromJson(json["created_by"]),
      dateCreated: json["date_created"],
      name: json["name"],
      category: ExpenseCategory.fromJson(json["category"]),
      value: json["value"],
      description: json["description"],
      items: jsonItems.map((dynamic item) => ExpenseItem.fromJson(item)).toList(),
    );
  }
}
