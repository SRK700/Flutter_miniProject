import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProductForm extends StatefulWidget {
  final Map<String, dynamic> data;

  EditProductForm({required this.data});

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController unitOfMeasureController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    productNameController.text = widget.data['product_name'].toString();
    unitOfMeasureController.text = widget.data['unit_of_measure'].toString();
    sellingPriceController.text = widget.data['selling_price'].toString();
  }

  Future<void> updateProductData() async {
    String productCode = widget.data['product_code'].toString();
    String productName = productNameController.text;
    String unitOfMeasure = unitOfMeasureController.text;
    String sellingPrice = sellingPriceController.text;

    String apiUrl = 'http://localhost:81//API_mn/update_product.php';

    Map<String, dynamic> requestBody = {
      'product_code': productCode,
      'product_name': productName,
      'unit_of_measure': unitOfMeasure,
      'selling_price': sellingPrice,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message
        print('Product updated successfully');

        // After successful update, navigate back to the previous screen
        Navigator.pop(context);
      } else {
        // Handle error, e.g., show an error message
        print('Failed to update product. ${response.body}');
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
        title: Text('Edit Product'),
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
                    // If the form is valid, call the function to update product data
                    updateProductData();
                  }
                },
                child: Text('Update'),
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
