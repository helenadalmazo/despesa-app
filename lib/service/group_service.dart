import 'package:despesa_app/model/group.dart';
import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/service/base_service.dart';

class GroupService {

  GroupService.privateConstructor();
  static final GroupService instance = GroupService.privateConstructor();

  static final _baseService = BaseService("/group");

  Future<List<Group>> list() async {
    dynamic response = await _baseService.get(
      ""
    );
    List<dynamic> responseList = response;
    return responseList
        .map((dynamic item) => Group.fromJson(item))
        .toList();
  }

  Future<Group> save(String name) async {
    dynamic response = await _baseService.post(
      "",
      <String, String> {
        "name": name
      }
    );
    return Group.fromJson(response);
  }

  Future<Group> update(int id, String name) async {
    dynamic response = await _baseService.put(
      "/$id",
      <String, String> {
        'name': name
      }
    );
    return Group.fromJson(response);
  }

  Future<Group> get(int id) async {
    dynamic response = await _baseService.get(
      "/$id"
    );
    return Group.fromJson(response);
  }

  Future<Map<String, dynamic>> delete(int id) async {
    dynamic response = await _baseService.delete(
      "/$id",
    );
    return response["success"];
  }

  Future<List<User>> searchNewUser(int id, String fullName) async {
    dynamic response = await _baseService.get(
      "/$id/searchnewuser?fullname=$fullName"
    );
    List<dynamic> body = response;
    return body.map((dynamic item) => User.fromJson(item)).toList();
  }

  Future<Group> addUser(int id, int userId, String role) async {
    dynamic response = await _baseService.post(
      "/$id/adduser/$userId",
      <String, String> {
        "role": role
      }
    );
    return Group.fromJson(response);
  }

  Future<Group> removeUser(int id, int userId) async {
    dynamic response = await _baseService.delete(
      "/$id/removeuser/$userId",
    );
    return Group.fromJson(response);
  }

  Future<Group> updateUser(int id, int userId, String role) async {
    dynamic response = await _baseService.put(
      "/$id/updateuser/$userId",
      <String, String> {
        'role': role
      }
    );
    return Group.fromJson(response);
  }
}
