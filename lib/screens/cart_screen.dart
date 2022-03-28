import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final productIds = cart.items.keys.toList(growable: false);
    final cartItems = cart.items.values.toList(growable: false);
    final orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                     Spacer(),
                      Chip(
                        label: Text(
                          '\$${cart.totalAmount}',
                          style: TextStyle(color: Theme
                              .of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color),
                        ),
                        backgroundColor: Theme
                            .of(context)
                            .primaryColor,
                      ),
                      TextButton(onPressed: () {
                        orders.addOrder(cartItems, cart.totalAmount);
                        cart.clear();
                      }, child: Text('ORDER NOW'))
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (_, int index) {
                    return CartItem(id: cartItems[index].id,
                        productId: productIds[index],
                        title: cartItems[index].title,
                        quantity: cartItems[index].quantity,
                        price: cartItems[index].price);
                  },
                  itemCount: cart.items.length
                ),
            ),
          ],
        ));
  }
}
