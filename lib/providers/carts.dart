import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;

  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    //kiem tra mat hang da co trong gio hang chua, neu co thif tang so luong neu khong thi them vao gio hang
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity + 1,
                price: existingCartItem.price,
              )); //goi ham cartItem vaof cung cap vao gia tri hien co tai productId
    } //neu items da co chua Id trong gio hang thi tang so luong
    else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSinglerCart(String productId) {
    if (!_items.containsKey(
        productId)) {
      //kiem tra xem san pham co phai la cua cua hang hay khong theo key id,
      return;
    } //neu khong thi return khong lam gi het
    else if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity - 1,
                price: existingCartItem.price,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
