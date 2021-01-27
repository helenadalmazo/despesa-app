class MoneyUtils {

  static String formatCurrency(double value) {
    String valueWithTwoDecimalPoint = value.toStringAsFixed(2);

    valueWithTwoDecimalPoint = valueWithTwoDecimalPoint.replaceAll(".", ",");

    return "R\$ $valueWithTwoDecimalPoint";
  }

}