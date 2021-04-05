class StatisticValueGroupedByCategory {
  final String group;
  final double value;

  StatisticValueGroupedByCategory({
    this.group,
    this.value,
  });

  factory StatisticValueGroupedByCategory.fromJson(Map<String, dynamic> json) {
    return StatisticValueGroupedByCategory(
        group: json["group"],
        value: json["value"]
    );
  }
}