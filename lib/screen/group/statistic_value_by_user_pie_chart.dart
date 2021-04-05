import 'package:charts_flutter/flutter.dart' as charts;
import 'package:despesa_app/formatter/percentage_format.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticValueByUserPieChart extends StatelessWidget {
  final bool animate;
  final List<StatisticValueGroupedByUser> statisticValueByUser;
  double _totalValue;

  StatisticValueByUserPieChart({
    Key key,
    @required this.animate,
    @required this.statisticValueByUser
  }) : super(key: key) {
    _totalValue = statisticValueByUser.map((statistic) => statistic.value).reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: statisticValueByUser == null
            ? Center(child: CircularProgressIndicator())
            : charts.PieChart(
          [
            charts.Series<StatisticValueGroupedByUser, String>(
              id: "statisticValueByUser",
              domainFn: (StatisticValueGroupedByUser statistic, _) => statistic.user.getFirstName(),
              measureFn: (StatisticValueGroupedByUser statistic, _) => statistic.value,
              colorFn: (StatisticValueGroupedByUser statistic, _) {
                Color color = statistic.user.getColor();
                return charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
              },
              data: statisticValueByUser,
              labelAccessorFn: (StatisticValueGroupedByUser statistic, _) => PercentageFormat.format(statistic.value/_totalValue * 100),
            )
          ],
          animate: animate,
          layoutConfig: charts.LayoutConfig(
            leftMarginSpec: charts.MarginSpec.fixedPixel(0),
            topMarginSpec: charts.MarginSpec.fixedPixel(0),
            rightMarginSpec: charts.MarginSpec.fixedPixel(8),
            bottomMarginSpec:charts.MarginSpec.fixedPixel(0),
          ),
          behaviors: [
            charts.DatumLegend(
              position: charts.BehaviorPosition.top,
              outsideJustification: charts.OutsideJustification.startDrawArea,
              desiredMaxRows: 2,
            )
          ],
          defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 50,
            arcRendererDecorators: [
              charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.inside
              ),
            ],
          ),
        )
    );
  }
}