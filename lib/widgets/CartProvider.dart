import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(Map<String, dynamic> item) {
    item['quantity'] =
        item['quantity'] ?? 1; // initialize quantity if not provided
    item['price'] = item['price'] ?? 0.0; // initialize price if not provided
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void increaseItemQuantity(int index) {
    if (_items[index]['quantity'] != null) {
      _items[index]['quantity']++;
    } else {
      _items[index]['quantity'] = 1;
    }
    notifyListeners();
  }

  void decreaseItemQuantity(int index) {
    if (_items[index]['quantity'] != null && _items[index]['quantity'] > 1) {
      _items[index]['quantity']--;
    } else {
      _items[index]['quantity'] = 1;
    }
    notifyListeners();
  }

  int get itemCount => _items.length;

  double get totalPrice => _items.fold(
      0,
      (total, item) =>
          total + (item['price'] ?? 0.0) * (item['quantity'] ?? 1));
}
