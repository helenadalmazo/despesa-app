import 'dart:convert';

import 'package:despesa_app/auth/authentication.dart';
import 'package:despesa_app/model/group_model.dart';
import 'package:http/http.dart' as http;

class GroupRepository {

  GroupRepository.privateConstructor();
  static final GroupRepository instance = GroupRepository.privateConstructor();

  Future<List<Group>> list() async {
    final response = await http.get(
      'http://10.0.2.2:5000/group/',
      headers: <String, String> {
        'Authorization': Authentication.instance.getAuthorization(),
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Group.fromJson(item)).toList();
    }

    throw Exception('todo');
  }
}
