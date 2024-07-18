import 'dart:convert'; // Add this import for jsonDecode

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Products> products = []; // List to store products
  bool isGridMode = false; // Flag to toggle between grid and list view

  @override
  void initState() {
    super.initState();
    _loadSavedProducts(); // Load saved products on screen initialization
  }

  Future<void> _loadSavedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      products = Products.listFromJson(prefs.getStringList('products') ?? []);
    });
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJson =
        products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList('products', productsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(isGridMode ? Icons.list : Icons.grid_on),
            onPressed: () {
              setState(() {
                isGridMode = !isGridMode;
              });
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddItemDialog(context);
        },
      ),
    );
  }

  Widget _buildBody() {
    if (products.isEmpty) {
      return Center(
        child: Text('No items added yet.'),
      );
    } else {
      return isGridMode ? _buildGridView() : _buildListView();
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(products[index].name),
            subtitle:
                Text('\$${products[index].price.toStringAsFixed(2)}'),
            leading: CircleAvatar(
              backgroundImage: products[index].picture.isNotEmpty
                  ? NetworkImage(products[index].picture)
                  : null,
              child: products[index].picture.isEmpty
                  ? Icon(Icons.shopping_bag)
                  : null,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditItemDialog(context, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, index);
                  },
                ),
              ],
            ),
            onTap: () {
              _showEditItemDialog(context, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: products[index].picture.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(products[index].picture),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: products[index].picture.isEmpty
                      ? Icon(Icons.shopping_bag)
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(products[index].name),
                    Text('\$${products[index].price.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditItemDialog(context, index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, index);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context) {
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemPriceController = TextEditingController();
    TextEditingController itemPictureController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: itemPriceController,
                  decoration: InputDecoration(labelText: 'Item Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: itemPictureController,
                  decoration: InputDecoration(
                      labelText: 'Item Picture URL (Optional)'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                String itemName = itemNameController.text;
                double itemPrice =
                    double.tryParse(itemPriceController.text) ?? 0.0;
                String itemPicture = itemPictureController.text;

                // Add item to list
                setState(() {
                  products.add(Products(
                      name: itemName, price: itemPrice, picture: itemPicture));
                });

                _saveProducts(); // Save products after adding a new one

                // Optionally, show a snackbar or perform any other action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item added: $itemName')),
                );

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(BuildContext context, int index) {
    TextEditingController itemNameController =
        TextEditingController(text: products[index].name);
    TextEditingController itemPriceController =
        TextEditingController(text: products[index].price.toString());
    TextEditingController itemPictureController =
        TextEditingController(text: products[index].picture);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: itemPriceController,
                  decoration: InputDecoration(labelText: 'Item Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: itemPictureController,
                  decoration: InputDecoration(
                      labelText: 'Item Picture URL (Optional)'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String itemName = itemNameController.text;
                double itemPrice =
                    double.tryParse(itemPriceController.text) ?? 0.0;
                String itemPicture = itemPictureController.text;

                // Update item in list
                setState(() {
                  products[index] = Products(
                    name: itemName,
                    price: itemPrice,
                    picture: itemPicture,
                  );
                });

                _saveProducts(); // Save products after editing

                // Optionally, show a snackbar or perform any other action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item edited: $itemName')),
                );

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete ${products[index].name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  products.removeAt(index);
                  _saveProducts(); // Save products after deletion
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class Products {
  final String name;
  final double price;
  final String picture;

  Products({required this.name, required this.price, this.picture = ''});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'picture': picture,
    };
  }

  static List<Products> listFromJson(List<String> jsonList) {
    return jsonList.map((json) {
      Map<String, dynamic> data = jsonDecode(json);
      return Products(
        name: data['name'],
        price: data['price'],
        picture: data['picture'],
      );
    }).toList();
  }
}
