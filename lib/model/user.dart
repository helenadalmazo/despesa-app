class User {
  final int id;
  final String username;
  final String fullName;

  User({
    this.id,
    this.username,
    this.fullName
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        fullName = json['full_name'];
}