class ExpenseItem {
  final int id;
  final int userId;
  final double value;

  ExpenseItem({
    this.id,
    this.userId,
    this.value
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      id: json['id'],
      userId: json['user_id'],
      value: json['value']
    );
  }
}
