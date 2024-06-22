import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsProvider {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('Products');

  Future<int> _getNextProductId() async {
    // Obține cel mai mare product_id din colecție și incrementează-l
    QuerySnapshot querySnapshot = await productsCollection
        .orderBy('product_id', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['product_id'] + 1;
    } else {
      return 1; // Dacă nu există produse, începe de la 1
    }
  }

  Future<void> addProduct({
    required String categoryId,
    required String name,
    required String description,
    required String imageUrl,
    required double price,
    required int stock,
  }) async {
    int productId = await _getNextProductId();
    await productsCollection.add({
      'product_id': productId,
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
