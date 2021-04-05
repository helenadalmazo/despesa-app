import 'package:charts_flutter/flutter.dart' as charts;
import 'package:despesa_app/formatter/date_format.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_year_month.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticValueByYearMonthBarChart extends StatelessWidget {
  final bool animate;
  final List<StatisticValueGroupedByYearMonth> statisticValueByYearMonth;

  StatisticValueByYearMonthBarChart({
    Key key,
    @required this.animate,
    @required this.statisticValueByYearMonth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: statisticValueByYearMonth == null
          ? Center(child: CircularProgressIndicator())
          : charts.BarChart(
        [
          charts.Series<StatisticValueGroupedByYearMonth, String>(
            id: "statisticValueByYearMonth",
            domainFn: (StatisticValueGroupedByYearMonth statistic, _) => DateFormat.formatYearMonth(statistic.date),
            measureFn: (StatisticValueGroupedByYearMonth statistic, _) => statistic.value,
            colorFn: (StatisticValueGroupedByYearMonth statistic, _) {
              Color color = Theme.of(context).primaryColorLight;
              return charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
            },
            data: statisticValueByYearMonth,
          )
        ],
        animate: animate,
      ),
    );
  }
}