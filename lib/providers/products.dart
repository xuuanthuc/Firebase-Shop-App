import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  //quan ly thong bao cac thay doi ben trong provider
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
  ];
  //[] vi khong co phan tu cuoi cung la no se thay doi theo thoi gian

  final String authToken;
  final String userId;
  Products(this.authToken,this.userId, this._items);
  List<Product> get items {
    return [..._items];
  } //getter tra ve danh sach cac san pham trong _item de dung cho class ben ngoai

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }


  Future<void> fetchAndSetProduct([bool filterByUser = false]) async{
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : ''; //xem filterByUser co true khong, neu khong tra ve rong ''
    var url =
        'https://shop-app-50b42-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';//loc userid theo id nguoi tao khi no bang nhau thi moi tra ve cac ket qua o ben duoi
    try{
      final response = await http.get(url);//post de gui yeu cau gui, get de yeu cau nhan
      if(response.statusCode == 200){
        Map<String, dynamic> _mapData = jsonDecode(response.body);
        final List<Product> loadedProduct = [];
        _mapData.forEach((pordId, pordData) {//duyet phan tu theo id la name va gia tri tra ve ben trong do gan vao pordData
          loadedProduct.add(Product(
            id: pordId,
            title: pordData['title'],
            description: pordData['description'],
            price: pordData['price'],
            imageUrl: pordData['imageUrl'],
          ));
        });
        _items = loadedProduct;
        notifyListeners();
      }
    }
    catch(error){
      throw error;
    }
  }


  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-50b42-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            //chuyen doi du lieu map sang JSON
            'title': product.title,
            //khoa 'title' nhan du lieu tu Product product
            'description': product.description,
            //khoa 'description' nhan du lieu tu Product product
            'imageUrl': product.imageUrl,
            //khoa 'imageUrl' nhan du lieu tu Product product
            'price': product.price,
            //khoa 'price' nhan du lieu tu Product product
            'creatorId': userId,
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners(); //yeu cau gui du lieu len DB qua url, body xac dinh phan than yeu cau la du lieu duoc dinh kem vao , nhan du lieu la loai JSON
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id); //prodIndex lay gia tri product co id moi trung voi id cu
    if (prodIndex >= 0) {
      final url = 'https://shop-app-50b42-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
    }));
      _items[prodIndex] = newProduct; //tao product moi nhan gia tri tu prodindex o tren
      notifyListeners();
    } else {
      print('.heelo..');
    }
  }

  void deleteProduct(String id) {
    final url = 'https://shop-app-50b42-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    http.delete(url);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
