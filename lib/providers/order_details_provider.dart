import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> createOrderDetails(String orderId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final cartSnapshot = await _firestore
          .collection('Cart')
          .where('user_id', isEqualTo: user.uid)
          .get();
      if (cartSnapshot.docs.isNotEmpty) {
        final cartId = cartSnapshot.docs.first.id;
        final cartItemsSnapshot = await _firestore
            .collection('Cart')
            .doc(cartId)
            .collection('items')
            .get();
        double total = 0;
        for (var item in cartItemsSnapshot.docs) {
          final data = item.data();
          final productId = data['product_id'];
          final quantity = data['quantity'];
          final price = data['price'];
          total += price * quantity;
          await _firestore.collection('Order Details').add({
            'order_id': orderId,
            'product_id': productId,
            'quantity': quantity,
            'total': price * quantity,
          });
        }
        notifyListeners();
      } else {
        throw Exception('No cart items found for user');
      }
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<double> calculateTotal(String orderId) async {
    double total = 0;
    final orderDetailsSnapshot = await _firestore
        .collection('Order Details')
        .where('order_id', isEqualTo: orderId)
        .get();

    for (var item in orderDetailsSnapshot.docs) {
      total += item.data()['total'];
    }
    return total;
  }
}
