import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Order;
import 'package:shop_app/widgets/app_drawer.dart';
import 'file:///G:/Flutter%20Project/shop_app/lib/screens/orders_screen/widgets_order/order_item.dart';

class OrderScreen extends StatelessWidget {
  Future<void> _refeshOrder(BuildContext context) async{
    await Provider.of<Order>(context, listen: false).fetchAndSetOrder();
  }
  static const routeName = 'order-screen';
  @override
  Widget build(BuildContext context) {

    // final order = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(//lay ket qua tu _refeshOrder truoc roi xay dung len list order
        future: _refeshOrder(context),
        builder:(ctx, snapshot)=> snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator(),) :
        Consumer<Order>( // chi lay provider trong widget nay va build lai widget nay tranh build lai ca trang, neu dung final order o tren se build lai ca trang lien tuc, tuong tu voi user_products_screen
          builder:(ctx, order, _) => RefreshIndicator(
            onRefresh: () => _refeshOrder(context),
            child: ListView.builder(
              itemBuilder: (ctx, i) => OrderItem(order.orders[i]),
              itemCount: order.orders.length,
            ),
          ),
        ),
      ),
    );
  }
}
