import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsProvider {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('Products');

  Future<void> addProduct({
    required String categoryId,
    required String name,
    required String description,
    required String imageUrl,
    required double price,
    required int stock,
  }) async {
    await productsCollection.add({
      'category_id': categoryId,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'stock': stock,
    });
  }

  Future<List<QueryDocumentSnapshot>> getProducts() async {
    QuerySnapshot querySnapshot = await productsCollection.get();
    return querySnapshot.docs;
  }
}
