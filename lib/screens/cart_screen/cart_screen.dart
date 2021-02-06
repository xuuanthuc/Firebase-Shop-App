import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/orders.dart';
import 'file:///G:/Flutter%20Project/shop_app/lib/screens/orders_screen/order_screen.dart';
import 'file:///G:/Flutter%20Project/shop_app/lib/screens/cart_screen/widgets_cart/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routerName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart !!!'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Spacer(),
                      Chip(
                        backgroundColor: Theme
                            .of(context)
                            .primaryColor,
                        label: Text(
                          '\$${cart.totalAmount}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      FlatButton (
                          onPressed: () async {
                            await Provider.of<Order>(context, listen: false).addOrder(
                                cart.items.values.toList(), cart.totalAmount);
                            cart.clear();
                            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
                          },
                          child: Text(
                            'Order Now', style: TextStyle(color: Colors.pink),))
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) =>
                  CartItemWidget(
                      cart.items.values.toList()[i].id,
                      //values cung cap mot thuoc tinh co the lap lai ma co the chuye doi thnah danh sach
                      cart.items.keys.toList()[i],
                      cart.items.values.toList()[i].title,
                      cart.items.values.toList()[i].quantity,
                      cart.items.values.toList()[i].price),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}
