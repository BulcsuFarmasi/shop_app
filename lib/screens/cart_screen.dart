import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItemKeys = cart.items.keys.toList(growable: false);
    final cartItemValues = cart.items.values.toList(growable: false);
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
                      TextButton(onPressed: () {}, child: Text('ORDER NOW'))
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, int index) {
                  return CartItem(id: cartItemValues[index].id,
                      productId: cartItemKeys[index],
                      title: cartItemValues[index].title,
                      quantity: cartItemValues[index].quantity,
                      price: cartItemValues[index].price);
                },
                itemCount: cart.itemCount,
              ),
            ),
          ],
        ));
  }
}
