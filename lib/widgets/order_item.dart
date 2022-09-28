import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({required Order this.order, Key? key}) : super(key: key);

  final Order order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final animationDuration = Duration(milliseconds: 300);
    final animationCurve = Curves.easeInOut;
    final double itemsHeight =  min(widget.order.items.length * 20 + 10, 100);
    final listTileHeight = 95.0;

    return AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      height: _expanded ? listTileHeight + itemsHeight : listTileHeight,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
            AnimatedContainer(
              duration: animationDuration,
              curve: animationCurve,
              height: (_expanded) ? itemsHeight : 0,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                  children: widget.order.items
                      .map((item) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.product.title,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${item.quantity} x \$${item.product.price}',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ))
                      .toList()),
            )
          ],
        ),
      ),
    );
  }
}
