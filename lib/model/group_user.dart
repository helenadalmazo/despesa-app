import 'package:despesa_app/model/group_user_role.dart';
import 'package:despesa_app/model/user.dart';

class GroupUser {
  final User user;
  final GroupUserRole role;

  GroupUser({
    this.user,
    this.role,
  });

  factory GroupUser.fromJson(Map<String, dynamic> json) {
    return GroupUser(
      user: User.fromJson(json["user"]),
      role: GroupUserRole.values.firstWhere((role) => role.toString() == "GroupUserRole.${json["role"]}")
    );
  }
}