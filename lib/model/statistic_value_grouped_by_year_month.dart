class StatisticValueGroupedByYearMonth {
  final String date;
  final double value;

  StatisticValueGroupedByYearMonth({
    this.date,
    this.value,
  });

  factory StatisticValueGroupedByYearMonth.fromJson(Map<String, dynamic> json) {
    return StatisticValueGroupedByYearMonth(
        date: json["date"],
        value: json["value"]
    );
  }
}