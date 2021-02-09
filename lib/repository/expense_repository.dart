import 'dart:convert';

import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/model/expense.dart';
import 'package:http/http.dart' as http;

class ExpenseRepository {

  ExpenseRepository.privateConstructor();
  static final ExpenseRepository instance = ExpenseRepository.privateConstructor();

  static final String _baseUrl = 'http://10.0.2.2:5000/expense/group';

  Future<List<Expense>> list(int groupId) async {
    final response = await http.get(
      "$_baseUrl/$groupId",
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Expense.fromJson(item)).toList();
    }

    throw Exception('TODO expense list exception');
  }

  Future<Expense> save(int groupId, String name, double value, String description, List<Map<String, dynamic>> items) async {
    final response = await http.post(
      '$_baseUrl/$groupId',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, dynamic> {
        'group_id': groupId,
        'name': name,
        'value': value,
        'description': description,
        'items': items
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      return Expense.fromJson(body);
    }

    throw Exception('TODO expense save exception');
  }

  Future<Expense> update(int groupId, int id, String name, double value, String description, List<Map<String, dynamic>> items) async {
    final response = await http.put(
      '$_baseUrl/$groupId/$id',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, dynamic> {
        'name': name,
        'value': value,
        'description': description,
        'items': items
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      return Expense.fromJson(body);
    }

    throw Exception('TODO expense update exception');
  }

  Future<Expense> get(int groupId, int id) async {
    final response = await http.get(
        '$_baseUrl/$groupId/$id',
        headers: <String, String> {
          'Authorization': Authentication.instance.getAuthorization(),
        }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      return Expense.fromJson(body);
    }

    throw Exception('TODO expense get exception');
  }

  Future<Map<String, dynamic>> delete(int groupId, int id) async {
    final response = await http.delete(
      '$_baseUrl/$groupId/$id',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('TODO expense delete exception');
  }
}
