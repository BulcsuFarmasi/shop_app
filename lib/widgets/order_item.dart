import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({required Order this.order, Key? key}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(order.date),
            ),
            trailing: IconButton(icon: Icon(Icons.expand_more), onPressed: () {},),
          )
        ],
      ),
    );
  }
}
