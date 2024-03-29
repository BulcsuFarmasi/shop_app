import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';
import 'package:shop_app/providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  static final routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  late Future _ordersFuture;


  Future _getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _ordersFuture = _getOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (BuildContext ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('An error occured'));
            } else {
              return Consumer<Orders>(builder: (ctx, orders, child) {
                return ListView.builder(
                    itemBuilder: (BuildContext ctx, int index) {
                      return OrderItem(
                        order: orders.items[index],
                      );
                    },
                    itemCount: orders.items.length);
              });
            }
          }
        },
      ),
    );
  }
}
