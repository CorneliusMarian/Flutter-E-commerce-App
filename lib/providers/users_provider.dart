import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      await _firestore.collection('Users').add({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'isAdmin': false, // Setăm isAdmin la false în mod implicit
      });
    } catch (error) {
      print('Failed to add user: $error');
    }
  }

  Future<Map<String, dynamic>?> authenticateUser(
      String email, String password) async {
    try {
      final querySnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    } catch (error) {
      print('Failed to authenticate user: $error');
    }
    return null;
  }
}