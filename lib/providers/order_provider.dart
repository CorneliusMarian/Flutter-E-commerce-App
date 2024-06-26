import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createOrder() async {
    final user = _auth.currentUser;
    if (user != null) {
      final cartSnapshot = await _firestore
          .collection('Cart')
          .where('user_id', isEqualTo: user.uid)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        final orderDoc = await _firestore.collection('Order').add({
          'user_id': user.uid,
          'status': 'netrimis',
          'created_at': Timestamp.now(),
        });

        final orderId = orderDoc.id;
        notifyListeners();
        return orderId;
      } else {
        throw Exception('No cart found for user');
      }
    } else {
      throw Exception('User not logged in');
    }
  }
}
