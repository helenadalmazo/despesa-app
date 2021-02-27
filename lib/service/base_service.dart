import 'dart:convert';

import 'package:despesa_app/exception/ApiException.dart';
import 'package:despesa_app/service/authentication_service.dart';
import 'package:http/http.dart' as http;

typedef CreateModelFromJson = dynamic Function(dynamic json);

class BaseService {

  static final String _baseUrl = "http://10.0.2.2:5000";

  final String basePath;

  BaseService(this.basePath);

  Future<dynamic> get(String path) async {
    final response = await http.get(
      "$_baseUrl$basePath$path",
      headers: _getHeaders()
    );

    return _onResponse(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> payload) async {
    final response = await http.post(
      "$_baseUrl$basePath$path",
      headers: _getHeaders(),
      body: json.encode(payload),
    );

    return _onResponse(response);
  }

  Future<dynamic> put(String path, Map<String, dynamic> payload) async {
    final response = await http.put(
      "$_baseUrl$basePath$path",
      headers: _getHeaders(),
      body: json.encode(payload),
    );

    return _onResponse(response);
  }

  Future<dynamic> delete(String path) async {
    final response = await http.delete(
      "$_baseUrl$basePath$path",
      headers: _getHeaders()
    );

    return _onResponse(response);
  }

  dynamic _onResponse(http.Response response) {
    dynamic responseJson = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    }

    throw ApiException.fromJson(responseJson);
  }

  Map<String, String> _getHeaders() {
    return  {
      "Authorization": "Bearer ${AuthenticationService.token}",
      "Content-Type": "application/json; charset=UTF-8",
    };
  }
}