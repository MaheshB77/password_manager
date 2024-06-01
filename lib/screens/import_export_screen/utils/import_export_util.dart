class ImportExportUtil {
  static Map<String, List<Map<String, dynamic>>> cardExportFormat(
    List<Map<String, dynamic>> cardCategoriesList,
    List<Map<String, dynamic>> cardList,
  ) {
    return {
      'cards': cardList,
      'cardCategories': cardCategoriesList,
    };
  }

  static Map<String, List<Map<String, dynamic>>> passwordExportFormat(
    List<Map<String, dynamic>> passwordCategories,
    List<Map<String, dynamic>> passwords,
  ) {
    return {
      'passwords': passwords,
      'passwordCategories': passwordCategories,
    };
  }
}
