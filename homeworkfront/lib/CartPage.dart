import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CartProvider.dart';
import 'ProductDetailPage.dart';

class CartPage extends StatelessWidget {
  final int userid;

  CartPage({required this.userid});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: cartProvider.fetchCartItems(userid),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<CartProvider>(
              builder: (ctx, cartProvider, child) {
                final items = cartProvider.items.values.toList();
                if (items.isEmpty) {
                  print('Cart is empty');
                  return Center(
                      child: Text('Your cart is empty',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)));
                }
                print('Cart loaded with ${cartProvider.items.length} items');
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (ctx, i) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: items[i].product,
                                  userId: userid,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      items[i].product.imageurl,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          items[i].product.productName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () async {
                                                try {
                                                  await cartProvider
                                                      .removeSingleItem(
                                                          userid,
                                                          items[i]
                                                              .product
                                                              .productId);
                                                } catch (error) {
                                                  print(
                                                      'Error removing single item from cart: $error');
                                                }
                                              },
                                            ),
                                            Text(
                                                'Quantity: ${items[i].quantity}'),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () async {
                                                try {
                                                  await cartProvider.addItem(
                                                      userid, items[i].product);
                                                } catch (error) {
                                                  print(
                                                      'Error adding item to cart: $error');
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '\$${items[i].product.price * items[i].quantity}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            await cartProvider.removeItem(
                                                userid,
                                                items[i].product.productId);
                                          } catch (error) {
                                            print(
                                                'Error removing item from cart: $error');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total: \$${cartProvider.totalPrice}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: Text('Checkout', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
