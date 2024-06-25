import 'package:cloud_firestore/cloud_firestore.dart';

class CartsProvider {
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('Carts');

  Future<String> createOrGetActiveCart(String userId) async {
    QuerySnapshot querySnapshot =
        await cartCollection.where('user_id', isEqualTo: userId).get();
    if (querySnapshot.docs.isEmpty) {
      DocumentReference newCart = await cartCollection.add({
        'user_id': userId,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      return newCart.id;
    } else {
      return querySnapshot.docs.first.id;
    }
  }

  Future<void> updateCartTimestamp(String cartId) async {
    await cartCollection.doc(cartId).update({
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
