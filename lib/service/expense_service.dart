import 'package:despesa_app/model/expense.dart';
import 'package:despesa_app/service/base_service.dart';

class ExpenseService {

  ExpenseService.privateConstructor();
  static final ExpenseService instance = ExpenseService.privateConstructor();

  static final _baseService = BaseService("/expense/group");

  Future<List<Expense>> list(int groupId) async {
    dynamic response = await _baseService.get(
      "/$groupId"
    );
    List<dynamic> responseList = response;
    return responseList
        .map((dynamic item) => Expense.fromJson(item))
        .toList();
  }

  Future<Expense> save(int groupId, String name, double value, String description, List<Map<String, dynamic>> items) async {
    dynamic response = await _baseService.post(
      "/$groupId",
      <String, dynamic> {
        "group_id": groupId,
        "name": name,
        "value": value,
        "description": description,
        "items": items
      }
    );
    return Expense.fromJson(response);
  }

  Future<Expense> update(int groupId, int id, String name, double value, String description, List<Map<String, dynamic>> items) async {
    dynamic response = await _baseService.put(
      "$groupId/$id",
      <String, dynamic> {
        "name": name,
        "value": value,
        "description": description,
        "items": items
      }
    );
    return Expense.fromJson(response);
  }

  Future<Expense> get(int groupId, int id) async {
    dynamic response = await _baseService.get(
      "/$groupId/$id"
    );
    return Expense.fromJson(response);
  }

  Future<bool> delete(int groupId, int id) async {
    dynamic response = await _baseService.delete(
      "/$groupId/$id"
    );
    return response["success"];
  }
}
