import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildItemCard('Hot Drinks', 'HotDrink2.gif', HotDrinksData.hotDrinks),
            SizedBox(height: 10),
            _buildItemCard('Cold Drinks', 'lemonade.gif', ColdDrinksData.coldDrinks),
            SizedBox(height: 10),
            _buildItemCard('Cakes', 'cake.gif', CakesData.cakes),
            SizedBox(height: 10),
            _buildItemCard('Sandwiches', 'sandwich.gif', SandwichesData.sandwiches),
            ElevatedButton(
              onPressed: () {
                _uploadItemsDataToFirebase();
              },
              child: Text('Upload Items Data to FB'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(String category, String imagePath, List<ItemData> items) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () {
          _showItemDetailsDialog(category, imagePath, items);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/Images/$imagePath', width: 75, height: 80, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                category,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetailsDialog(String category, String imagePath, List<ItemData> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('lib/Images/$imagePath', width: 75, height: 100, fit: BoxFit.cover),
              SizedBox(height: 10),
              for (ItemData item in items)
                ListTile(
                  title: Text('${item.name} - ${item.price} JOD'),
                  subtitle: Text(item.description),
                ),
            ],
          ),
        );
      },
    );
  }

  void _uploadItemsDataToFirebase() {
    DatabaseReference itemsRef = FirebaseDatabase.instance.reference().child("items");

    for (String category in ['Hot Drinks', 'Cold Drinks', 'Cakes', 'Sandwiches']) {
      List<ItemData> items;
      String imagePath;

      switch (category) {
        case 'Hot Drinks':
          items = HotDrinksData.hotDrinks;
          imagePath = 'HotDrink2.gif';
          break;
        case 'Cold Drinks':
          items = ColdDrinksData.coldDrinks;
          imagePath = 'lemonade.gif';
          break;
        case 'Cakes':
          items = CakesData.cakes;
          imagePath = 'cake.gif';
          break;
        case 'Sandwiches':
          items = SandwichesData.sandwiches;
          imagePath = 'sandwich.gif';
          break;
        default:
          items = [];
          imagePath = '';
      }

      for (ItemData item in items) {
        DatabaseReference itemRef = itemsRef.child(category).push();
        itemRef.set({
          'name': item.name,
          'price': item.price,
          'description': item.description,
          'imagePath': imagePath,
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Items data uploaded to Firebase!'),
    ));
  }
}
class ItemData {
  final String name;
  final double price;
  final String description;

  ItemData(this.name, this.price, this.description);
}

class HotDrinksData {
  static final List<ItemData> hotDrinks = [
    ItemData('Coffee', 1.0, 'The best fresh-roasted coffee beans in Jordan!'),
    ItemData('Tea', 1.0, 'Hot tea served with fresh mint leaves.'),
    ItemData('Hot Chocolate', 1.0, 'Top-quality Belgian chocolate. Pure cocoa butter.'),
  ];
}

class ColdDrinksData {
  static final List<ItemData> coldDrinks = [
    ItemData('Iced Coffee', 2.0, 'Refreshing coffee served with ice cubes & caramel.'),
    ItemData('Lemonade', 2.0, 'Fresh cold lemonade made of the best harvest Lemon in local Jordanian farms.'),
    ItemData('Fruit Smoothie', 2.0, 'Fruit cocktail mixed with our special syrup served cold with ice cubes.'),
  ];
}

class CakesData {
  static final List<ItemData> cakes = [
    ItemData('Red Velvet', 2.5, '1 medium-size Red velvet piece.'),
    ItemData('Victoria', 2.5, '1 medium-size Victoria piece.'),
    ItemData('Lemon', 2.5, '1 medium-size Lemon piece.'),
  ];
}

class SandwichesData {
  static final List<ItemData> sandwiches = [
    ItemData('Chicken Avocado', 1.5, 'Fresh local Chicken with special Avocado sauce sandwich.'),
    ItemData('Grilled Cheese', 1.5, 'A grilled Sandwich of our best cheese mix.'),
    ItemData('Beef Sandwich', 1.5, 'Our top seller Sandwich. Fresh Beef served with a special BBQ sauce.'),
  ];
}
