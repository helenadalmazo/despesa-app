class TextFormFieldValidator {

  static String validateMandatory(String value) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

}