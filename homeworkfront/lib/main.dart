import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CartProvider.dart';
import 'LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TrendRoad',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: LoginPage(),
      ),
    );
  }
}
