import 'package:despesa_app/model/group_user.dart';

class Group {
  final int id;
  final String name;
  final List<GroupUser> users;

  Group({
    this.id,
    this.name,
    this.users
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonUsers = json["users"];

    return Group(
      id: json["id"],
      name: json["name"],
      users: jsonUsers.map((dynamic item) => GroupUser.fromJson(item)).toList(),
    );
  }
}
