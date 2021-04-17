import 'package:despesa_app/model/balance.dart';
import 'package:despesa_app/model/expense.dart';
import 'package:despesa_app/model/expense_category.dart';
import 'package:despesa_app/service/base_service.dart';

class ExpenseService {

  ExpenseService.privateConstructor();
  static final ExpenseService instance = ExpenseService.privateConstructor();

  static final _baseService = BaseService("/expense");

  Future<List<Expense>> list(int groupId, int year, int month) async {
    dynamic response = await _baseService.get(
      "/group/$groupId?year=$year&month=$month"
    );
    List<dynamic> responseList = response;
    return responseList
        .map((dynamic item) => Expense.fromJson(item))
        .toList();
  }

  Future<Expense> save(int groupId, String name, int _categoryId, double value, String description, List<Map<String, dynamic>> items) async {
    dynamic response = await _baseService.post(
      "/group/$groupId",
      <String, dynamic> {
        "name": name,
        "category_id": _categoryId,
        "value": value,
        "description": description,
        "items": items
      }
    );
    return Expense.fromJson(response);
  }

  Future<Expense> update(int groupId, int id, String name, int categoryId, double value, String description, List<Map<String, dynamic>> items) async {
    dynamic response = await _baseService.put(
      "/group/$groupId/$id",
      <String, dynamic> {
        "name": name,
        "category_id": categoryId,
        "value": value,
        "description": description,
        "items": items
      }
    );
    return Expense.fromJson(response);
  }

  Future<Expense> get(int groupId, int id) async {
    dynamic response = await _baseService.get(
      "/group/$groupId/$id"
    );
    return Expense.fromJson(response);
  }

  Future<bool> delete(int groupId, int id) async {
    dynamic response = await _baseService.delete(
      "/group/$groupId/$id"
    );
    return response["success"];
  }

  Future<List<ExpenseCategory>> listCategories() async {
    dynamic response = await _baseService.get(
      "/categories"
    );
    List<dynamic> responseList = response;
    return responseList
        .map((dynamic item) => ExpenseCategory.fromJson(item))
        .toList();
  }

  Future<Balance> balance(int groupId, int year, int month) async {
    dynamic response = await _baseService.get(
      "/group/$groupId/balance?year=$year&month=$month"
    );
    return Balance.fromJson(response);
  }
}
