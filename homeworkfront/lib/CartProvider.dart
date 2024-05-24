import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Product.dart';

class CartProvider with ChangeNotifier {
  Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => {..._items};

  double get totalPrice {
    return _items.values
        .fold(0.0, (sum, item) => sum + item.product.price * item.quantity);
  }

  Future<void> fetchCartItems(int userId) async {
    final url = 'http://localhost:8080/api/cart/$userId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> cartData = json.decode(response.body);
        _items.clear();
        cartData.forEach((itemData) {
          final productData = itemData['product'];
          _items[productData['productid']] = CartItem(
            product: Product(
              productId: productData['productid'],
              productName: productData['productname'],
              price: productData['price'],
              category: productData['category'],
              imageurl: productData['imageurl'],
            ),
            quantity: itemData['quantity'],
          );
        });
        notifyListeners();
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (error) {
      print('fetchCartItems error: $error');
      throw error;
    }
  }

  Future<void> addItem(int userId, Product product) async {
    if (_items.containsKey(product.productId)) {
      _items.update(
        product.productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.productId,
        () => CartItem(
          product: product,
          quantity: 1,
        ),
      );
    }
    notifyListeners();

    final url = 'http://localhost:8080/api/cart/add';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userid': userId,
          'productid': product.productId,
          'quantity': 1,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add item to cart');
      }
    } catch (error) {
      print('addItem error: $error');
      throw error;
    }
  }

  Future<void> removeItem(int userId, int productId) async {
    _items.remove(productId);
    notifyListeners();

    final url = 'http://localhost:8080/api/cart/remove';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userid': userId,
          'productid': productId,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove item from cart');
      }
    } catch (error) {
      print('removeItem error: $error');
      throw error;
    }
  }

  Future<void> removeSingleItem(int userId, int productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();

    final url = 'http://localhost:8080/api/cart/removeSingle';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userid': userId,
          'productid': productId,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove single item from cart');
      }
    } catch (error) {
      print('removeSingleItem error: $error');
      throw error;
    }
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}
