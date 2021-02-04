import 'dart:convert';

import 'package:despesa_app/auth/authentication.dart';
import 'package:http/http.dart' as http;

class StatisticRepository {

  StatisticRepository.privateConstructor();
  static final StatisticRepository instance = StatisticRepository.privateConstructor();

  static final String _baseUrl = 'http://10.0.2.2:5000/statistic';

  Future<List<Map<String, dynamic>>> listValueGroupedByUser(int groupId) async {
    final response = await http.get(
      '$_baseUrl/valuegroupedbyuser/group/$groupId',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => { 'user': item['user'], 'value': item['value']}).toList();
    }

    throw Exception('TODO statistic listValueGroupedByUser exception');
  }

  Future<List<Map<String, dynamic>>> listValueGroupedByYearMonth(int groupId) async {
    final response = await http.get(
        '$_baseUrl/valuegroupedbyyearmonth/group/$groupId',
        headers: <String, String> {
          'Authorization': Authentication.instance.getAuthorization(),
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) {
        return { 'date': item['date'], 'value': item['value']};
      }).toList();
    }

    throw Exception('TODO statistic listValueGroupedByYearMonth exception');
  }
}
