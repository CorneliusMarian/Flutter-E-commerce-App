import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemsProvider {
  final CollectionReference cartItemsCollection =
      FirebaseFirestore.instance.collection('CartItems');

  Future<void> addOrUpdateCartItem(
      {required String cartId,
      required String productId,
      required int quantity}) async {
    QuerySnapshot querySnapshot = await cartItemsCollection
        .where('cart_id', isEqualTo: cartId)
        .where('product_id', isEqualTo: productId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      await cartItemsCollection.add({
        'cart_id': cartId,
        'product_id': productId,
        'quantity': quantity,
      });
    } else {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      await cartItemsCollection.doc(documentSnapshot.id).update({
        'quantity': quantity,
      });
    }
  }

  Future<void> removeCartItem(String cartItemId) async {
    await cartItemsCollection.doc(cartItemId).delete();
  }
}
