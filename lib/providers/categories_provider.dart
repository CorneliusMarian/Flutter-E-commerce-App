import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesProvider {
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('Categories');

  Future<void> addDefaultCategories() async {
    List<Map<String, String>> defaultCategories = [
      {'name': 'Barbati', 'description': 'Produse pentru barbati'},
      {'name': 'Femei', 'description': 'Produse pentru femei'},
      {'name': 'Copii', 'description': 'Produse pentru copii'}
    ];

    for (var category in defaultCategories) {
      QuerySnapshot existingCategories = await categoriesCollection
          .where('name', isEqualTo: category['name'])
          .get();

      if (existingCategories.docs.isEmpty) {
        await categoriesCollection.add(category);
      }
    }
  }

  Future<List<QueryDocumentSnapshot>> getCategories() async {
    QuerySnapshot querySnapshot = await categoriesCollection.get();
    return querySnapshot.docs;
  }
}
