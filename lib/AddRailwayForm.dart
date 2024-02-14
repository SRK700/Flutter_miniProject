import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRailwayForm extends StatefulWidget {
  @override
  _AddRailwayFormState createState() => _AddRailwayFormState();
}

class _AddRailwayFormState extends State<AddRailwayForm> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  Future<void> _addRailway() async {
    final String apiUrl = 'http://localhost:81//API_mn/add_railway.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "code": _codeController.text,
        "car_number": _carNumberController.text,
      },
    );

    if (response.statusCode == 200) {
      // ดำเนินการตอนที่เพิ่มข้อมูลสำเร็จ
      print('Railway added successfully');
      // ตรวจสอบ response.body เพื่อดูข้อมูลที่ได้จากเซิร์ฟเวอร์ (ถ้ามี)
    } else {
      // ดำเนินการตอนที่มีข้อผิดพลาดเกิดขึ้น
      print('Failed to add railway. Error: ${response.statusCode}');
      // ตรวจสอบ response.body เพื่อดูข้อมูลที่ได้จากเซิร์ฟเวอร์ (ถ้ามี)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Railway'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Code'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _carNumberController,
              decoration: InputDecoration(labelText: 'Car Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // เมื่อกดปุ่ม "Add Railway"
                _addRailway();
              },
              child: Text('Add Railway'),
            ),
          ],
        ),
      ),
    );
  }
}
