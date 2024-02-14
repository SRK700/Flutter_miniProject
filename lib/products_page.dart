import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddProductForm.dart';
import 'EditProductForm.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Map<String, dynamic>>> _productsData;

  Future<List<Map<String, dynamic>>> _fetchProductsData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81//API_mn/select_product.php'));

    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  Future<void> _deleteProduct(int productCode) async {
    String apiUrl = 'http://localhost:81//API_mn/delete_product.php';
    Map<String, dynamic> requestBody = {'product_code': productCode.toString()};

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        print('Product deleted successfully');
        setState(() {
          _productsData = _fetchProductsData();
        });
      } else {
        print('Failed to delete product. ${response.body}');
      }
    } catch (error) {
      print('Error connecting to the server: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _productsData = _fetchProductsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductForm(),
                ),
              ).then((_) {
                // Refresh data after returning from AddProductForm
                setState(() {
                  _productsData = _fetchProductsData();
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูล'));
          } else {
            return DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text('Product Code')),
                DataColumn(label: Text('Product Name')),
                DataColumn(label: Text('Unit of Measure')),
                DataColumn(label: Text('Selling Price')),
                DataColumn(label: Text('Actions')),
              ],
              rows: snapshot.data!.map((data) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(data['product_code'].toString())),
                    DataCell(Text(data['product_name'].toString())),
                    DataCell(Text(data['unit_of_measure'].toString())),
                    DataCell(Text(data['selling_price'].toString())),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProductForm(data: data),
                                ),
                              ).then((_) {
                                // Refresh data after returning from EditProductForm
                                setState(() {
                                  _productsData = _fetchProductsData();
                                });
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteProduct(int.parse(data['product_code']));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
