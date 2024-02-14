import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditRailwayPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditRailwayPage({required this.data});

  @override
  _EditRailwayPageState createState() => _EditRailwayPageState();
}

class _EditRailwayPageState extends State<EditRailwayPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController carNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial value for carNumberController based on received data
    carNumberController.text = widget.data['car_number'].toString();
  }

  Future<void> updateRailwayData() async {
    String apiUrl = 'http://localhost:81//API_mn/updateRailway.php';

    Map<String, dynamic> requestBody = {
      'code': widget.data['code'].toString(),
      'car_number': carNumberController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message
        print('Data updated successfully');

        // After successful update, navigate back to the previous screen
        Navigator.pop(context);
      } else {
        // Handle error, e.g., show an error message
        print('Failed to update data. ${response.body}');
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
        title: Text('Edit Railway Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: carNumberController,
                decoration: InputDecoration(
                  labelText: 'Car Number',
                  icon: Icon(Icons.train),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a car number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, call the function to update railway data
                    updateRailwayData();
                  }
                },
                child: Text('Update'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent,
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

void main() {
  runApp(MaterialApp(
    home: EditRailwayPage(data: {}), // Pass initial data if needed
    theme: ThemeData(
      primaryColor: Colors.orange, // Set your desired primary color
    ),
  ));
}
