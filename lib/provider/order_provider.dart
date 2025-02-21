import 'package:flutter/material.dart';
import '../models/order_item.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void setOrders(List<Order> orders) {
    _orders = orders;
    notifyListeners();
  }
}