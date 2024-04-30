import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pembelian',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PurchasePage(),
    );
  }
}

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  int totalItems = 0;
  int totalPrice = 0;

  // Menambahkan list produk untuk setiap kategori
  final List<Map<String, dynamic>> keychainProducts = [
    {'name': 'Keychain A', 'price': 50000, 'quantity': 0},
    {'name': 'Keychain B', 'price': 30000, 'quantity': 0},
  ];

  final List<Map<String, dynamic>> stickerProducts = [
    {'name': 'Sticker A', 'price': 20000, 'quantity': 0},
    {'name': 'Sticker B', 'price': 15000, 'quantity': 0},
  ];

  final List<Map<String, dynamic>> photoCardProducts = [
    {'name': 'Photo Card A', 'price': 10000, 'quantity': 0},
    {'name': 'Photo Card B', 'price': 12000, 'quantity': 0},
  ];

  final List<Map<String, dynamic>> posterProducts = [
    {'name': 'Poster A', 'price': 40000, 'quantity': 0},
    {'name': 'Poster B', 'price': 45000, 'quantity': 0},
  ];

  Widget productList(List<Map<String, dynamic>> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(products[index]['name']),
          subtitle: Text('IDR ${products[index]['price']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (products[index]['quantity'] > 0) {
                      products[index]['quantity']--;
                      totalItems--;
                      totalPrice -= products[index]['price'] as int;
                    }
                  });
                },
              ),
              Text('${products[index]['quantity']}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    products[index]['quantity']++;
                    totalItems++;
                    totalPrice += products[index]['price'] as int;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Keychain'),
              Tab(text: 'Sticker'),
              Tab(text: 'Photo Card'),
              Tab(text: 'Poster'),
            ],
          ),
          title: Text('Total Penjualan: $totalItems Items'),
        ),
        body: TabBarView(
          children: [
            productList(keychainProducts),
            productList(stickerProducts),
            productList(photoCardProducts),
            productList(posterProducts),
          ],
        ),
      ),
    );
  }
}
