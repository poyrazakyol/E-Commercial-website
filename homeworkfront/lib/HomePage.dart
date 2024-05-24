import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'CartPage.dart';
import 'CartProvider.dart';
import 'Product.dart';
import 'ProductDetailPage.dart';
import 'User.dart';
import 'UserInfoPage.dart';

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];
  List<Product> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/products'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Product> products =
          body.map((dynamic item) => Product.fromJson(item)).toList();
      setState(() {
        _products = products;
        _searchResults = products;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<User> _fetchUserInfo() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/userinfo/${widget.userId}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return User.fromJson(body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<void> _searchProducts(String searchTerm) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/products/search?searchTerm=$searchTerm'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Product> products =
          body.map((dynamic item) => Product.fromJson(item)).toList();
      setState(() {
        _searchResults = products;
      });
    } else {
      throw Exception('Failed to search products');
    }
  }

  void _navigateToUserInfo() async {
    try {
      User user = await _fetchUserInfo();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoPage(user: user),
        ),
      );
    } catch (error) {
      print('Error fetching user info: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load user info'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('lib/images/logo.png', height: 80),
            SizedBox(width: 10),
            Text('TrendRoad',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.redAccent, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(userid: widget.userId),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.blueAccent, size: 28),
            onPressed: _navigateToUserInfo,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by product name or category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      suffixIcon: Icon(Icons.search, color: Colors.redAccent),
                    ),
                    onChanged: (value) {
                      _searchProducts(value);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryButton('Home', _fetchProducts, Icons.home),
                      _buildCategoryButton(
                          'Book', () => _searchProducts('Book'), Icons.book),
                      _buildCategoryButton('Technology',
                          () => _searchProducts('Technology'), Icons.devices),
                      _buildCategoryButton(
                          'Clothing',
                          () => _searchProducts('Clothing'),
                          Icons.shopping_bag),
                      _buildCategoryButton('Decoration',
                          () => _searchProducts('Decoration'), Icons.chair),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8A2387),
              Color(0xFFE94057),
              Color(0xFFF27121),
            ],
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            return _buildProductCard(_searchResults[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      String title, VoidCallback onPressed, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          side: BorderSide(color: Colors.grey, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: product,
              userId: widget.userId,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage('${product.imageurl}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                product.category,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                product.productName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${product.price}',
                style: TextStyle(fontSize: 14, color: Colors.redAccent),
              ),
              SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(widget.userId, product)
                        .catchError((error) {
                      print('Error adding item to cart: $error');
                    });
                  },
                  child: Text('Add to Cart',
                      style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
