import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addAddress({
    required String streetName,
    required String city,
    required String country,
    required String postalCode,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('Address').add({
        'user_id': user.uid,
        'street_name': streetName,
        'city': city,
        'country': country,
        'postal_code': postalCode,
      });
      notifyListeners();
    } else {
      print('User not logged in');
    }
  }
}
