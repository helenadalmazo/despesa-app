class DateTimeUtils {

  static DateTime fromYearMonthString(String value) {
    List<String> splitValue = value.split("-");

    int year = int.parse(splitValue[0]);
    int month = int.parse(splitValue[1]);

    return DateTime(year, month);
  }

}