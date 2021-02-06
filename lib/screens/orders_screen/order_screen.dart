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

    final order = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refeshOrder(context),
        child: ListView.builder(
          itemBuilder: (ctx, i) => OrderItem(order.orders[i]),
          itemCount: order.orders.length,
        ),
      ),
    );
  }
}
