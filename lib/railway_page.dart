import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddRailwayForm.dart'; // Import form for adding railway data
import 'EditRailway.dart'; // Import page for editing railway data

class RailwayPage extends StatefulWidget {
  @override
  _RailwayPageState createState() => _RailwayPageState();
}

class _RailwayPageState extends State<RailwayPage> {
  late Future<List<Map<String, dynamic>>> _railwayData;

  Future<List<Map<String, dynamic>>> _fetchRailwayData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81//API_mn/selectRailway.php'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  Future<void> _deleteRailway(String code) async {
    final response = await http.post(
      Uri.parse('http://localhost:81//API_mn/deleteRailway.php'),
      body: {'code': code},
    );

    if (response.statusCode == 200) {
      // Reload the data after deletion
      setState(() {
        _railwayData = _fetchRailwayData();
      });
    } else {
      // Handle error, e.g., show an error message
      print('Failed to delete data. ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    _railwayData = _fetchRailwayData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        leading: IconButton(
          icon: Icon(Icons.home_outlined),
          color: Colors.black,
          onPressed: () {},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Railway',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRailwayForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _railwayData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูล'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/icon1.png',
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Railway',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20.0,
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      dataRowColor:
                          MaterialStateProperty.all<Color>(Colors.blue.shade50),
                      columns: <DataColumn>[
                        DataColumn(
                          label: Icon(Icons.train, color: Colors.blue.shade400),
                        ),
                        DataColumn(label: Text('code')),
                        DataColumn(label: Text('car Number')),
                        DataColumn(
                          label: Text('Edit'),
                        ),
                        DataColumn(
                          label: Text('Delete'),
                        ),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.train,
                                    color: Colors.blue.shade400),
                                onPressed: () {
                                  // Implement logic to show details for the selected data
                                  // ...
                                },
                              ),
                            ),
                            DataCell(Text(data['code'].toString())),
                            DataCell(Text(data['car_number'].toString())),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditRailwayPage(data: data),
                                    ),
                                  );
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Implement logic to delete the selected data
                                  _deleteRailway(data['code'].toString());
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
