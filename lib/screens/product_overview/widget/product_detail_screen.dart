import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {

  static const routeName =
      '/product-detail'; //Đặt tên tuyến đường để truyền dữ liệu vào đây
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments
        as String; //Ben kia gui id, ben nay nhan id theo kieu String
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productId); //truy cao vao san pham cos id trung voi id cu the
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
              child: Image.network(loadedProduct.imageUrl)),
        ],
      ),
    );
  }
}
