import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(Map<String, dynamic> item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  int get itemCount => _items.length;

  double get totalPrice =>
      _items.fold(0, (total, item) => total + item['price']);
}
