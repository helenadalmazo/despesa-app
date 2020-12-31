class Group {
  final int id;
  final String name;

  Group({
    this.id,
    this.name
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
    );
  }
}
