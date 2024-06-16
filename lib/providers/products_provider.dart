import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductsProvider {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('Products');

  Future<void> addProduct({
    required String productId,
    required String categoryId,
    required String name,
    required String description,
    required String imageUrl,
    required double price,
    required int stock,
  }) async {
    await products
        .add({
          'product_id': productId,
          'category_id': categoryId,
          'name': name,
          'description': description,
          'image_url': imageUrl,
          'price': price,
          'stock': stock,
        })
        .then((value) => print("Product Added"))
        .catchError((error) => print("Failed to add product: $error"));
  }

  Future<List<String>> getImagesFromStorage(String path) async {
    final ListResult result =
        await FirebaseStorage.instance.ref(path).listAll();
    final List<String> urls = await Future.wait(
        result.items.map((Reference ref) => ref.getDownloadURL()).toList());
    return urls;
  }
}
