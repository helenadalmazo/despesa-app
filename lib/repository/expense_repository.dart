import 'dart:convert';

import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/model/expense.dart';
import 'package:http/http.dart' as http;

class ExpenseRepository {

  ExpenseRepository.privateConstructor();
  static final ExpenseRepository instance = ExpenseRepository.privateConstructor();

  static final String _baseUrl = 'http://10.0.2.2:5000/expense';

  Future<List<Expense>> list() async {
    final response = await http.get(
      _baseUrl,
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
}
