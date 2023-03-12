import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kami_saiyo_admin_panel/models/order_model.dart';

class OrdersProvider extends ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders = [];
      // ordersList.clear();
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
            0,
            OrderModel(
                orderId: element.get('orderId'),
                userId: element.get('userId'),
                productId: element.get('productId'),
                userName: element.get('userName'),
                price: element.get('price').toString(),
                imageUrl: element.get('imageUrl'),
                quantity: element.get('quantity').toString(),
                orderDate: element.get('orderDate')));
      });
    });
    notifyListeners();
  }

  OrderModel findProdById(String productId) {
    return _orders.firstWhere((element) => element.orderId == productId);
  }
}
