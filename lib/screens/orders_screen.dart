import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static final routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: MainDrawer(),
        body: ListView.builder(
          itemBuilder: (BuildContext ctx, int index) {
            return OrderItem(
              order: orders.items[index],
            );
          },
          itemCount: orders.items.length,
        ));
  }
}
