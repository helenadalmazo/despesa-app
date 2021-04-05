extension DiacriticsTreatement on String {
  static const diacritics =
      "ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž";
  static const nonDiacritics =
      "AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz";

  String removeDiacritics() {
    return this.splitMapJoin("",
      onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
        ? nonDiacritics[diacritics.indexOf(char)]
        : char);
  }
}