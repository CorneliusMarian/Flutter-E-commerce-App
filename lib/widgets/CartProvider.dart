import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _items = [];
  String _cartId = '';

  List<Map<String, dynamic>> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice => _items.fold(
      0,
      (total, item) =>
          total + (item['price'] ?? 0.0) * (item['quantity'] ?? 1));

  Future<void> _initializeCart() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (_cartId.isEmpty) {
        final cartDoc = await _firestore.collection('Cart').add({
          'user_id': user.uid,
          'created_at': Timestamp.now(),
          'updated_at': Timestamp.now(),
        });
        _cartId = cartDoc.id;
        print('Cart created with ID: $_cartId');
      } else {
        // Check if the cart document exists
        final cartSnapshot =
            await _firestore.collection('Cart').doc(_cartId).get();
        if (!cartSnapshot.exists) {
          print('Cart document not found, creating a new one.');
          final cartDoc = await _firestore.collection('Cart').add({
            'user_id': user.uid,
            'created_at': Timestamp.now(),
            'updated_at': Timestamp.now(),
          });
          _cartId = cartDoc.id;
          print('New cart created with ID: $_cartId');
        }
      }
    } else {
      print('User not logged in');
    }
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    await _initializeCart();

    item['quantity'] =
        item['quantity'] ?? 1; // Initialize quantity if not provided
    item['price'] = item['price'] ?? 0.0; // Initialize price if not provided

    final existingItemIndex =
        _items.indexWhere((i) => i['product_id'] == item['product_id']);
    // if (existingItemIndex >= 0) {
    //   _items[existingItemIndex]['quantity'] += item['quantity'];
    // } else {
    _items.add({
      'product_id': item['product_id'],
      'name': item['name'],
      'price': item['price'],
      'image_url': item['image_url'],
      'quantity': item['quantity'],
    });
    // }

    // Add or update item in Firestore if cartId is not empty
    if (_cartId.isNotEmpty) {
      await _firestore
          .collection('Cart')
          .doc(_cartId)
          .collection('items')
          .doc(item['product_id'])
          .set({
        'name': item['name'],
        'price': item['price'],
        'image_url': item['image_url'],
        'quantity': item['quantity'],
      });

      // Update cart's updated_at field
      await _firestore.collection('Cart').doc(_cartId).update({
        'updated_at': Timestamp.now(),
      });
    }

    notifyListeners();
  }

  Future<void> removeItem(int index) async {
    await _initializeCart();

    final productId = _items[index]['product_id'];
    _items.removeAt(index);

    // Remove item from Firestore if cartId is not empty
    if (_cartId.isNotEmpty) {
      await _firestore
          .collection('Cart')
          .doc(_cartId)
          .collection('items')
          .doc(productId)
          .delete();

      // Update cart's updated_at field
      await _firestore.collection('Cart').doc(_cartId).update({
        'updated_at': Timestamp.now(),
      });
    }

    notifyListeners();
  }

  void increaseItemQuantity(int index) async {
    if (_items[index]['quantity'] != null) {
      _items[index]['quantity']++;
    } else {
      _items[index]['quantity'] = 1;
    }

    final productId = _items[index]['product_id'];

    // Update item quantity in Firestore if cartId is not empty
    if (_cartId.isNotEmpty) {
      try {
        await _firestore
            .collection('Cart')
            .doc(_cartId)
            .collection('items')
            .doc(productId)
            .update({'quantity': _items[index]['quantity']});
        // Update cart's updated_at field
        await _firestore.collection('Cart').doc(_cartId).update({
          'updated_at': Timestamp.now(),
        });
        print('Item quantity updated in Firestore');
      } catch (e) {
        print('Failed to update item quantity in Firestore: $e');
      }
    } else {
      print('Cart ID is empty, cannot update item quantity');
    }

    notifyListeners();
  }

  void decreaseItemQuantity(int index) async {
    if (_items[index]['quantity'] != null && _items[index]['quantity'] > 1) {
      _items[index]['quantity']--;
    } else {
      _items[index]['quantity'] = 1;
    }

    final productId = _items[index]['product_id'];

    // Update item quantity in Firestore if cartId is not empty
    if (_cartId.isNotEmpty) {
      try {
        await _firestore
            .collection('Cart')
            .doc(_cartId)
            .collection('items')
            .doc(productId)
            .update({'quantity': _items[index]['quantity']});
        // Update cart's updated_at field
        await _firestore.collection('Cart').doc(_cartId).update({
          'updated_at': Timestamp.now(),
        });
        print('Item quantity updated in Firestore');
      } catch (e) {
        print('Failed to update item quantity in Firestore: $e');
      }
    } else {
      print('Cart ID is empty, cannot update item quantity');
    }

    notifyListeners();
  }
}
