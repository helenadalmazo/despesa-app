import 'package:despesa_app/model/user.dart';

class Split {
  final User payer;
  final User receiver;
  final double value;

  Split({
    this.payer,
    this.receiver,
    this.value
  });

  factory Split.fromJson(Map<String, dynamic> json) {
    return Split(
        payer: User.fromJson(json["payer"]),
        receiver: User.fromJson(json["receiver"]),
        value: json["value"]
    );
  }
}