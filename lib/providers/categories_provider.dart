class CategoriesProvider {
  static const List<Map<String, String>> categories = [
    {
      'category_id': 'cat1',
      'name': 'Men\'s Shoes',
    },
    {
      'category_id': 'cat2',
      'name': 'Women\'s Shoes',
    },
    {
      'category_id': 'cat3',
      'name': 'Children\'s Shoes',
    },
    // Adaugă alte categorii aici
  ];

  List<Map<String, String>> getCategories() {
    return categories;
  }
}
