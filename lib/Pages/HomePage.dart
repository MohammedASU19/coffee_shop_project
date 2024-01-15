import 'package:flutter/material.dart';
import 'package:coffee_shop_project/Drawer/Drawer.dart';
import 'package:coffee_shop_project/Pages/LoginPage.dart';
import 'package:coffee_shop_project/Pages/RegisterationPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            // Replace the coffee icon with your logo
            Image.asset(
              'lib/Images/mhs_logo.png',
              width: 100,
              height: 100, 
            ),
            //SizedBox(width: 8),
            //Text('MHS Coffee Shop'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'lib/Images/Shopbackground5.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Content on top of the background
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_cafe, size: 50, color: Colors.brown),
                  SizedBox(height: 20),
                  Text(
                    'Thirsty for Coffee? Welcome to our shop!',
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Login and order now!',
                    style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    icon: Icon(Icons.login),
                    label: Text('Login here'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationPage()),
                      );
                    },
                    icon: Icon(Icons.person_add),
                    label: Text('Register here'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

