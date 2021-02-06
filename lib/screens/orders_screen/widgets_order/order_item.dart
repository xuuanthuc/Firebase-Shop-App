import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {

  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expandedMore = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon:
                    Icon(_expandedMore ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expandedMore = !_expandedMore;
                  });
                },
              ),
            ),
            if (_expandedMore)
              Container(
                height: min(widget.order.products.length * 20.0 + 30, 180),
                child: ListView(
                  children: widget.order.products.map((prod) => Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(prod.title, style: TextStyle(fontWeight: FontWeight.bold),),
                        Text('${prod.quantity} x \$${prod.price}')
                      ],
                    ),
                  )).toList(),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
