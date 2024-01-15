import 'package:coffee_shop_project/Pages/Feedback.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop_project/Pages/LoginPage.dart';
import 'package:coffee_shop_project/Pages/RegisterationPage.dart';
import 'package:coffee_shop_project/Pages/HomePage.dart';
import 'package:coffee_shop_project/Pages/ItemDetails.dart';
import 'package:coffee_shop_project/Pages/Profile.dart';
import 'package:coffee_shop_project/Pages/OrderList.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(251, 242, 231, 1),
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset('lib/images/time.gif', width: 100, height: 100),
          ),
          buildListTile(Icons.home, "Home Page", () => navigateTo(HomePage())),
          buildListTile(Icons.person, "Profile", () => navigateTo(ProfilePage())),
          buildListTile(Icons.food_bank_rounded, "Order Page", () => navigateTo(ItemDetailPage())),
          buildListTile(Icons.list_rounded, "Items list", () => navigateTo(OrderListPage())),
          buildListTile(Icons.account_box_rounded, "Registration Page", () => navigateTo(RegistrationPage())),
          buildListTile(Icons.contact_mail, "Login Page", () => navigateTo(LoginPage())),
          buildListTile(Icons.stars_rounded, "Rate us", () => navigateTo(FeedbackPage()))
          
        ],
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the drawer before navigating
        onTap();
      },
    );
  }

  void navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
