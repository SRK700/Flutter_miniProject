import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController unitOfMeasureController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();

  Future<void> addProductData() async {
    String productName = productNameController.text;
    String unitOfMeasure = unitOfMeasureController.text;
    String sellingPrice = sellingPriceController.text;

    String apiUrl = 'http://localhost:81//API_mn/add_product.php';

    Map<String, dynamic> requestBody = {
      'product_name': productName,
      'unit_of_measure': unitOfMeasure,
      'selling_price': sellingPrice,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message
        print('Product added successfully');

        // After successful save, navigate back to the previous screen
        Navigator.pop(context);
      } else {
        // Handle error, e.g., show an error message
        print('Failed to add product. ${response.body}');
      }
    } catch (error) {
      // Handle error, e.g., show an error message
      print('Error connecting to the server: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  icon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: unitOfMeasureController,
                decoration: InputDecoration(
                  labelText: 'Unit of Measure',
                  icon: Icon(Icons.straighten),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit of measure';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: sellingPriceController,
                decoration: InputDecoration(
                  labelText: 'Selling Price',
                  icon: Icon(Icons.monetization_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a selling price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, call the function to add product data
                    addProductData();
                  }
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
