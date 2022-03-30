import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  static final routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Orders orders;
  bool _isInitilized = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInitilized) {
      setState(() {
        _isLoading = true;
      });
      orders = Provider.of<Orders>(context);

      orders.fetchOrders().catchError((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Couldn\'t load Orders'),
        ));
      }).whenComplete(() => setState(() {
            _isLoading = false;
          }));
    }
    _isInitilized = true;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: MainDrawer(),
        body: (_isLoading)
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (BuildContext ctx, int index) {
                  return OrderItem(
                    order: orders.items[index],
                  );
                },
                itemCount: orders.items.length,
              ));
  }
}
