import 'package:flutter/material.dart';

class ItemDetailPage extends StatefulWidget {
  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  Map<String, double> itemPrices = {
    'Coffee': 1.0,
    'Tea': 1.0,
    'Hot Chocolate': 1.0,
    'Iced Coffee': 2.0,
    'Lemonade': 2.0,
    'Fruit Smoothie': 2.0,
    'Red Velvet': 2.5,
    'Victoria': 2.5,
    'Lemon': 2.5,
    'Chicken Avocado': 1.5,
    'Grilled Cheese': 1.5,
    'Beef Sandwich': 1.5,
  };

  List<String> selectedItems = [];

  // For credit card details
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildItemList(
                      'Hot Drinks',
                      ['Coffee', 'Tea', 'Hot Chocolate'],
                      Icons.local_cafe,
                      'HotDrink2.gif', // Image path for Hot Drinks
                    ),
                  ),
                  Expanded(
                    child: _buildItemList(
                      'Cold Drinks',
                      ['Iced Coffee', 'Lemonade', 'Fruit Smoothie'],
                      Icons.icecream,
                      'lemonade.gif', // Image path for Cold Drinks
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildItemList(
                      'Cakes',
                      ['Red Velvet', 'Victoria', 'Lemon'],
                      Icons.cake,
                      'cake.gif', // Image path for Cakes
                    ),
                  ),
                  Expanded(
                    child: _buildItemList(
                      'Sandwiches',
                      ['Chicken Avocado', 'Grilled Cheese', 'Beef Sandwich'],
                      Icons.fastfood,
                      'sandwich.gif', // Image path for Sandwiches
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedItems.isNotEmpty) {
                  _showPaymentMethodDialog();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select at least one item before placing an order.'),
                    ),
                  );
                }
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList(String title, List<String> items, IconData icon, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 24),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Image.asset('lib/Images/$imagePath', width: 50, height: 50),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(
                  '${items[index]} - ${itemPrices[items[index]]} JOD',
                  style: TextStyle(fontSize: 16),
                ),
                value: selectedItems.contains(items[index]),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      selectedItems.add(items[index]);
                    } else {
                      selectedItems.remove(items[index]);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please select your payment method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Cash'),
                leading: Icon(Icons.money),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'Cash';
                  });
                  Navigator.of(context).pop();
                  _showOrderConfirmationSnackBar();
                },
              ),
              ListTile(
                title: Text('Credit/Debit Card'),
                leading: Icon(Icons.credit_card),
                onTap: () {
                  _showCreditCardPaymentDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreditCardPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Credit/Debit Card Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(labelText: 'Credit Card Number'),
              ),
              TextFormField(
                controller: _expDateController,
                decoration: InputDecoration(labelText: 'Expiration Date'),
              ),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedPaymentMethod = 'Credit/Debit Card';
                  });
                  Navigator.of(context).pop();
                  _showOrderConfirmationSnackBar();
                },
                child: Text('Pay'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrderConfirmationSnackBar() {
    if (selectedPaymentMethod.isNotEmpty) {
      double totalPrice = 0.0;
      for (String item in selectedItems) {
        totalPrice += itemPrices[item]!;
      }

      var snackbar = SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your order has been successfully placed!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Selected Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            for (String item in selectedItems) Text('- $item (${itemPrices[item]} JOD)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text(
              'Total Price: $totalPrice JOD',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Payment Method: $selectedPaymentMethod',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select your payment method.'),
        ),
      );
    }
  }



  
}
