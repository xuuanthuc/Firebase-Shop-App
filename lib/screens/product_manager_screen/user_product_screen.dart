import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import 'package:shop_app/screens/edit_products_screen/edit_products_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import 'widgets_product_manager/user_product_widget.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  
  Future<void> _refeshProduct(BuildContext context) async{
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName))
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refeshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, i) => Column(
              children: [
                UserProduct(
                  products.items[i].id,
                  products.items[i].title,
                  products.items[i].imageUrl,
                ),
                Divider()
              ],
            ),
            itemCount: products.items.length,
          ),
        ),
      ),
    );
  }
}
