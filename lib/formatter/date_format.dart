class DateFormat {

  static String formatNow() {
    DateTime now = DateTime.now();

    String day = now.day.toString().padLeft(2, "0");
    String month = now.month.toString().padLeft(2, "0");
    String year = now.year.toString();

    month = getMonthAbbreviation(int.parse(month));

    return "$day/$month/$year";
  }

  static String format(String value) {
    List<String> splitValue = value.split("-");

    String year = splitValue[0];
    String month = splitValue[1];
    String day = splitValue[1];

    month = getMonthAbbreviation(int.parse(month));

    return "$day/$month/$year";
  }

  static String formatYearMonth(String value) {
    List<String> splitValue = value.split("-");

    String year = splitValue[0];
    String month = splitValue[1];

    year = year.substring(2, 4);
    month = getMonthAbbreviation(int.parse(month));

    return "$month/$year";
  }

  static String getMonthAbbreviation(int value) {
    switch (value) {
      case DateTime.january:
        return "jan";
      case DateTime.february:
        return "fev";
      case DateTime.march:
        return "mar";
      case DateTime.april:
        return "abr";
      case DateTime.may:
        return "maio";
      case DateTime.june:
        return "jun";
      case DateTime.july:
        return "jul";
      case DateTime.august:
        return "ago";
      case DateTime.september:
        return "set";
      case DateTime.october:
        return "out";
      case DateTime.november:
        return "nov";
      case DateTime.december:
        return "dez";
    }
    throw Exception("Abbreviation not found for month $value");
  }

}