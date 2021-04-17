class Statement {
  final int expenseId;
  final int expenseItemId;
  final String name;
  final double value;

  Statement({
    this.expenseId,
    this.expenseItemId,
    this.name,
    this.value
  });

  factory Statement.fromJson(Map<String, dynamic> json) {
    return Statement(
        expenseId: json["expense_id"],
        expenseItemId: json["expense_item_id"],
        name: json["name"],
        value: json["value"]
    );
  }
}