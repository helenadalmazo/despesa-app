class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  NotFoundException.fromJson(Map<String, dynamic> json)
      : message = json['message'];
}