import 'dart:convert';

import 'package:despesa_app/model/user.dart';
import 'package:http/http.dart' as http;

class Authentication {

  String _token;
  int _expiresIn;

  Authentication._privateConstructor();
  static final Authentication instance = Authentication._privateConstructor();

  static final String _baseUrl = 'http://10.0.2.2:5000/auth';

  void signUp() {
    throw 'TODO signUp';
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      '$_baseUrl/token/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String>{
        'username': username,
        'password': password
      }),
    );

    Map<String, dynamic> body = json.decode(response.body);

    if (response.statusCode == 200) {
      _token = body['token'];
      _expiresIn = body['expires_in'];

      return {
        'success': true
      };
    }

    return {
      'success': false,
      'message': body['message']
    };
  }

  Future<User> _me() async {
    throw 'TODO me';
  }
}