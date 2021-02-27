import 'package:despesa_app/model/statistic_value_grouped_by_user.dart';
import 'package:despesa_app/model/statistic_value_grouped_by_year_month.dart';
import 'package:despesa_app/service/base_service.dart';

class StatisticService {

  StatisticService.privateConstructor();
  static final StatisticService instance = StatisticService.privateConstructor();

  static final _baseService = BaseService("/statistic");

  Future<List<StatisticValueGroupedByUser>> listValueGroupedByUser(int groupId) async {
    dynamic response = await _baseService.get(
      "/valuegroupedbyuser/group/$groupId"
    );
    List<dynamic> responseList = response;
    return responseList
        .map((dynamic item) => StatisticValueGroupedByUser.fromJson(item))
        .toList();
  }

  Future<List<StatisticValueGroupedByYearMonth>> listValueGroupedByYearMonth(int groupId) async {
    dynamic response = await _baseService.get(
      "/valuegroupedbyyearmonth/group/$groupId"
    );
    List<dynamic> responseList = response;
    return responseList
        .map((dynamic item) => StatisticValueGroupedByYearMonth.fromJson(item))
        .toList();
  }
}
