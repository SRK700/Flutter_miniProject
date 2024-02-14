import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463023/main.dart';
import 'package:mn_641463023/register.dart';
import 'package:mn_641463023/menu_Screen.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void submitLogin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    String apiUrl = 'http://localhost:81//API_mn/checklogin.php';

    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context);
      } else {
        showLoginErrorDialog(context);
      }
    } catch (error) {
      showNotConnectDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blue, // เปลี่ยนสี AppBar
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('images/sp.png'),
                width: 150.0,
                height: 150.0,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Login Name:',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  submitLogin(context);
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // เปลี่ยนสีปุ่ม
                  onPrimary: Colors.white, // เปลี่ยนสีข้อความปุ่ม
                ),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RegisterUserForm(),
                    ),
                  );
                },
                child: Text('Register!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotConnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error Connection???'),
          content: Text('Your Connection Error..'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดป๊อปอัพ
              },
              child: Text('Go Back'),
            ),
          ],
        );
      },
    );
  }

  void showLoginErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text('Username & Password Not found..'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดป๊อปอัพ
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully'),
          content: Text('Your information has been successfully saved..'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(),
                  ),
                );
              },
              child: Text('Go to Menu'),
            ),
          ],
        );
      },
    );
  }
}
