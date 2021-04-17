import 'package:despesa_app/model/split.dart';
import 'package:despesa_app/model/statement.dart';

class Balance {
  final double balance;
  final List<Statement> statement;
  final List<Split> split;

  Balance({
    this.balance,
    this.statement,
    this.split
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonStatement = json["statement"];
    List<dynamic> jsonSplit = json["split"];

    return Balance(
        balance: json["balance"],
        statement: jsonStatement.map((dynamic item) => Statement.fromJson(item)).toList(),
        split: jsonSplit.map((dynamic item) => Split.fromJson(item)).toList()
    );
  }
}