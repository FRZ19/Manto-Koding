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

  List<Map<String, dynamic>> keychainProducts = [
    {'name': 'Keychain A', 'price': '50rb', 'quantity': 0},
    {'name': 'Keychain B', 'price': '30rb', 'quantity': 0},
  ];

  List<Map<String, dynamic>> stickerProducts = [
    {'name': 'Sticker A', 'price': '20rb', 'quantity': 0},
    {'name': 'Sticker B', 'price': '15rb', 'quantity': 0},
  ];

  List<Map<String, dynamic>> photoCardProducts = [
    {'name': 'Photo Card A', 'price': '10rb', 'quantity': 0},
    {'name': 'Photo Card B', 'price': '12rb', 'quantity': 0},
  ];

  List<Map<String, dynamic>> posterProducts = [
    {'name': 'Poster A', 'price': '40rb', 'quantity': 0},
    {'name': 'Poster B', 'price': '45rb', 'quantity': 0},
  ];

  void editProduct(List<Map<String, dynamic>> products, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _nameController =
            TextEditingController(text: products[index]['name']);
        final _priceController =
            TextEditingController(text: products[index]['price']);
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  products[index]['name'] = _nameController.text;
                  products[index]['price'] = _priceController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(List<Map<String, dynamic>> products, int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void addProduct(List<Map<String, dynamic>> products) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _nameController = TextEditingController();
        final _priceController = TextEditingController();
        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  products.add({
                    'name': _nameController.text,
                    'price': _priceController.text,
                    'quantity': 0,
                  });
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

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
                icon: Icon(Icons.edit),
                onPressed: () => editProduct(products, index),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleteProduct(products, index),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (products[index]['quantity'] > 0) {
                      products[index]['quantity']--;
                      totalItems--;
                      totalPrice -= int.parse(
                          products[index]['price'].replaceAll('rb', ''));
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
                    totalPrice += int.parse(
                        products[index]['price'].replaceAll('rb', ''));
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget addProductForm(List<Map<String, dynamic>> products) {
    return Center(
      child: ElevatedButton(
        onPressed: () => addProduct(products),
        child: Text('Add Product'),
      ),
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
        ),
        body: TabBarView(
          children: [
            keychainProducts.isEmpty
                ? addProductForm(keychainProducts)
                : productList(keychainProducts),
            stickerProducts.isEmpty
                ? addProductForm(stickerProducts)
                : productList(stickerProducts),
            photoCardProducts.isEmpty
                ? addProductForm(photoCardProducts)
                : productList(photoCardProducts),
            posterProducts.isEmpty
                ? addProductForm(posterProducts)
                : productList(posterProducts),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total Penjualan: $totalItems Items - IDR $totalPrice'),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Membuat daftar item yang telah dikonfirmasi
                          List<Widget> confirmedItemsList = [];
                          for (var product in keychainProducts) {
                            if (product['quantity'] > 0) {
                              confirmedItemsList.add(Text(
                                  '${product['name']}: ${product['quantity']}'));
                            }
                          }
                          for (var product in stickerProducts) {
                            if (product['quantity'] > 0) {
                              confirmedItemsList.add(Text(
                                  '${product['name']}: ${product['quantity']}'));
                            }
                          }
                          for (var product in photoCardProducts) {
                            if (product['quantity'] > 0) {
                              confirmedItemsList.add(Text(
                                  '${product['name']}: ${product['quantity']}'));
                            }
                          }
                          for (var product in posterProducts) {
                            if (product['quantity'] > 0) {
                              confirmedItemsList.add(Text(
                                  '${product['name']}: ${product['quantity']}'));
                            }
                          }

                          return AlertDialog(
                            title: const Text('Konfirmasi Pesanan'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  const Text(
                                      'Apakah Anda yakin ingin mengkonfirmasi pesanan ini?'),
                                  ...confirmedItemsList,
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Tutup dialog
                                },
                                child: const Text('Tidak'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Logika untuk mengkonfirmasi pesanan
                                  Navigator.of(context).pop(); // Tutup dialog
                                },
                                child: const Text('Iya'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Konfirmasi Pesanan'),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2.0, color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
