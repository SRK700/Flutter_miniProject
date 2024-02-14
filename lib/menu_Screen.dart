import 'package:flutter/material.dart';
import 'railway_page.dart';
import 'products_page.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.2,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle icon tap and navigate to the respective screens
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RailwayPage()),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RailwayPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RailwayPage()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RailwayPage()),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsPage()),
                  );
                  break;
                case 5:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RailwayPage()),
                  );
                  break;
                default:
                  break;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'Images/icon${index + 1}.png',
                    width: 70.0,
                    height: 70.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    getMenuTitle(index),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getMenuTitle(int index) {
    switch (index) {
      case 0:
        return 'Tram';
      case 1:
        return 'Tourist  information';
      case 2:
        return 'Bus route';
      case 3:
        return 'Store information';
      case 4:
        return 'Product';
      case 5:
        return 'tourist spot';
      default:
        return '';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuScreen(),
    theme: ThemeData(
      primaryColor: Colors.blueAccent, // Set your desired primary color
    ),
  ));
}
