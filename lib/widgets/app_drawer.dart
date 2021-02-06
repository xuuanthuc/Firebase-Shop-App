import 'package:flutter/material.dart';
import 'file:///G:/Flutter%20Project/shop_app/lib/screens/orders_screen/order_screen.dart';
import 'file:///G:/Flutter%20Project/shop_app/lib/screens/product_manager_screen/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Products Manager'),
            onTap: () => Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),
          ),
        ],
      ),
    );
  }
}
