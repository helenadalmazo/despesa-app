import 'dart:convert';

import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/user.dart';
import 'package:http/http.dart' as http;

class GroupRepository {

  GroupRepository.privateConstructor();
  static final GroupRepository instance = GroupRepository.privateConstructor();

  static final String _baseUrl = 'http://10.0.2.2:5000/group';

  Future<List<Group>> list() async {
    final response = await http.get(
      _baseUrl,
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Group.fromJson(item)).toList();
    }

    throw Exception('TODO group list exception');
  }

  Future<Group> save(String name) async {
    final response = await http.post(
      '$_baseUrl',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String> {
        'name': name
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      return Group.fromJson(body);
    }

    throw Exception('TODO group save exception');
  }

  Future<Group> update(int id, String name) async {
    final response = await http.put(
      '$_baseUrl/$id',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String> {
        'name': name
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      return Group.fromJson(body);
    }

    throw Exception('TODO group save exception');
  }

  Future<Group> get(int id) async {
    final response = await http.get(
      '$_baseUrl/$id',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
      }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      return Group.fromJson(body);
    }

    throw Exception('TODO group get exception');
  }

  Future<Map<String, dynamic>> delete(int id) async {
    final response = await http.delete(
      '$_baseUrl/$id',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('TODO group delete exception');
  }

  Future<List<User>> searchNewUser(int id, String fullName) async {
    final response = await http.get(
        '$_baseUrl/$id/searchnewuser?fullname=$fullName',
        headers: <String, String> {
          'Authorization': Authentication.instance.getAuthorization(),
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => User.fromJson(item)).toList();
    }

    throw Exception('TODO group searchNewUser exception');
  }

  Future<Group> addUser(int id, int userId, String role) async {
    final response = await http.post(
      '$_baseUrl/$id/adduser/$userId',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String> {
        'role': role
      }),
    );

    Map<String, dynamic> body = json.decode(response.body);

    if (response.statusCode == 200) {
      return Group.fromJson(body);
    }

    throw Exception('TODO group addUser exception');
  }

  Future<Group> removeUser(int id, int userId) async {
    final response = await http.delete(
        '$_baseUrl/$id/removeuser/$userId',
        headers: <String, String> {
          'Authorization': Authentication.instance.getAuthorization(),
        }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      return Group.fromJson(body);
    }

    throw Exception('TODO group removeUser exception');
  }

  Future<Group> updateUser(int id, int userId, String role) async {
    final response = await http.put(
        '$_baseUrl/$id/updateuser/$userId',
        headers: <String, String> {
          'Authorization': Authentication.instance.getAuthorization(),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String> {
          'role': role
        })
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      return Group.fromJson(body);
    }

    throw Exception('TODO group removeUser exception');
  }
}
