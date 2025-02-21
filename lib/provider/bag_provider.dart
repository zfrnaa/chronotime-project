// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../models/bag_item.dart';

class BagProvider with ChangeNotifier {
  final List<BagItem> _bagItems = [];

  List<BagItem> get bagItems => _bagItems;
  int get itemCount => _bagItems.length;

  void toggleItemSelection(String itemId, bool isSelected) {

    final index = bagItems.indexWhere((item) => item.id == itemId);

    if (index != -1) {

      bagItems[index].isSelected = isSelected;

      notifyListeners();

    }
  }

  // Add item to cart
  void addItem(BagItem item) {
    // Check if item already exists in cart
    final index = _bagItems.indexWhere((bagItem) => bagItem.id == item.id);
    if (index >= 0) {
      _bagItems[index].quantity += item.quantity;
    } else {
      _bagItems.add(item);
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String id) {
    _bagItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Increase quantity
  void increaseQuantity(String id) {
    final index = _bagItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _bagItems[index].quantity++;
      notifyListeners();
    }
  }

  // Decrease quantity
  void decreaseQuantity(String id) {
    final index = _bagItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (_bagItems[index].quantity > 1) {
        _bagItems[index].quantity--;
      } else {
        _bagItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Clear cart
  void clearCart() {
    _bagItems.clear();
    notifyListeners();
  }

  // Calculate total price
  double get totalPrice {
    return _bagItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }
}