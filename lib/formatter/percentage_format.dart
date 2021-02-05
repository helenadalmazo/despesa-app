class PercentageFormat {

  static String format(double value) {
    String valueWithTwoDecimalPoint = value.toStringAsFixed(2);

    valueWithTwoDecimalPoint = valueWithTwoDecimalPoint.replaceAll(".", ",");

    return "$valueWithTwoDecimalPoint %";
  }

}