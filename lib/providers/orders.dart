import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/carts.dart';
import 'package:intl/intl.dart';
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  final String authToken;
  final String userID;
  Order(this.authToken, this.userID, this._orders);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void removeOrder(String orderId) {
    _orders.remove(orderId);
    notifyListeners();
  }

  void addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://shop-app-50b42-default-rtdb.firebaseio.com/orders/$userID.json?auth=$authToken';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartProduct
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
          'dateTime': DateTime.now().toIso8601String(),
        }));
    print(json.decode(response.body));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProduct,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }

  Future<void> fetchAndSetOrder() async {
    final url =
        'https://shop-app-50b42-default-rtdb.firebaseio.com/orders/$userID.json?auth=$authToken';
    try {
      final response =
          await http.get(url); //post de gui yeu cau gui, get de yeu cau nhan
      if (response.statusCode == 200) {
        Map<String, dynamic> _mapData = jsonDecode(response.body);
        final List<OrderItem> loadedOrder = [];
        _mapData.forEach((pordId, pordData) {
          print(pordId);
          //duyet phan tu theo id la name va gia tri tra ve ben trong do gan vao pordData
          loadedOrder.add(OrderItem(
            id: pordId,
            amount: pordData['amount'],
            products: (pordData['products'] as List<dynamic>).map((e) =>
                CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'])).toList(),
            dateTime: DateTime.parse(pordData['dateTime']), 
          ));
        });
        _orders = loadedOrder;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}
