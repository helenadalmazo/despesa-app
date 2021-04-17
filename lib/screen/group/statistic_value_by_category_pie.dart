import 'package:charts_flutter/flutter.dart' as charts;
import 'package:despesa_app/formatter/percentage_format.dart';
import 'package:despesa_app/model/expense_category.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticValueByCategoryPieChart extends StatelessWidget {
  final bool animate;
  final List<StatisticValueGroupedByCategory> statisticValueByCategory;
  double _totalValue;

  StatisticValueByCategoryPieChart({
    Key key,
    @required this.animate,
    @required this.statisticValueByCategory
  }) : super(key: key) {
    if (statisticValueByCategory.isEmpty) _totalValue = 0;
    else _totalValue = statisticValueByCategory.map((statistic) => statistic.value).reduce((value, element) => value + element);
  }

  Widget _getBody(BuildContext context) {
    if (statisticValueByCategory == null) {
      return Center(
        child: CircularProgressIndicator()
      );
    }

    if (statisticValueByCategory.isEmpty) {
      return Center(
        child: Text(
          "Nenhum resultado encontrado"
        )
      );
    }

    return charts.PieChart(
      [
        charts.Series<StatisticValueGroupedByCategory, String>(
          id: "statisticValueByCategory",
          domainFn: (StatisticValueGroupedByCategory statistic, _) => statistic.group,
          measureFn: (StatisticValueGroupedByCategory statistic, _) => statistic.value,
          colorFn: (StatisticValueGroupedByCategory statistic, _) {
            Color color = ExpenseCategory.getColor(statistic.group);
            return charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
          },
          data: statisticValueByCategory,
          labelAccessorFn: (StatisticValueGroupedByCategory statistic, _) => PercentageFormat.format(statistic.value/_totalValue * 100),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _getBody(context)
    );
  }
}