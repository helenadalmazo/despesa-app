import 'dart:convert';

import 'package:despesa_app/model/statistic_value_grouped_by_user.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_year_month.dart';
import 'package:despesa_app/service/authentication_service.dart';
import 'package:http/http.dart' as http;

class StatisticService {

  StatisticService.privateConstructor();
  static final StatisticService instance = StatisticService.privateConstructor();

  static final String _baseUrl = 'http://10.0.2.2:5000/statistic';

  Future<List<StatisticValueGroupedByUser>> listValueGroupedByUser(int groupId) async {
    final response = await http.get(
      '$_baseUrl/valuegroupedbyuser/group/$groupId',
      headers: <String, String> {
        'Authorization': AuthenticationService.instance.getAuthorization(),
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => StatisticValueGroupedByUser.fromJson(item)).toList();
    }

    throw Exception('TODO statistic listValueGroupedByUser exception');
  }

  Future<List<StatisticValueGroupedByYearMonth>> listValueGroupedByYearMonth(int groupId) async {
    final response = await http.get(
        '$_baseUrl/valuegroupedbyyearmonth/group/$groupId',
        headers: <String, String> {
          'Authorization': AuthenticationService.instance.getAuthorization(),
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => StatisticValueGroupedByYearMonth.fromJson(item)).toList();
    }

    throw Exception('TODO statistic listValueGroupedByYearMonth exception');
  }
}
