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
      : id = json["id"],
        username = json["username"],
        fullName = json["full_name"];

  String getAcronym() {
    List<String> names = this.fullName.toUpperCase().split(" ");

    String firstName = names.first;
    if (names.length < 2) {
      return firstName[0];
    }

    String lastName = names.last;
    return firstName[0] + lastName[0];
  }
}