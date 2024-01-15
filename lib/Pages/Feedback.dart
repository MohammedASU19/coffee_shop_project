import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int serviceRating = 0;
  int foodRating = 0;
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/Images/ShopBackground3.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(maxWidth: 500),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildFeedbackItem('How was your service?', _buildStarRating(serviceRating)),
                          Divider(),
                          _buildFeedbackItem('How was the food?', _buildFaceRating(foodRating)),
                          Divider(),
                          _buildFeedbackItem(
                            'Write your feedback here..',
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                controller: feedbackController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Validate if both ratings are given
                              if (serviceRating > 0 && foodRating > 0) {
                                _showThankYouPopup();
                              } else {
                                _showIncompleteRatingPopup();
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Image.asset(
                      'lib/Images/chat.gif',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    Text('Email us at: MHS_Coffeehouse@asu.com', style: TextStyle(color: Colors.white)),
                    Text('Call us at: 00962778899', style: TextStyle(color: Colors.white)),
                    Text('Facebook page: @MHS_JO', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(String label, Widget content) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: content,
        ),
      ],
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStarIcon(1, rating),
        _buildStarIcon(2, rating),
        _buildStarIcon(3, rating),
        _buildStarIcon(4, rating),
        _buildStarIcon(5, rating),
      ],
    );
  }

  Widget _buildFaceRating(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFaceIcon('Excellent!', Icons.sentiment_very_satisfied, Colors.green, rating),
        _buildFaceIcon('Not bad..', Icons.sentiment_neutral, Colors.yellow, rating),
        _buildFaceIcon('Bad!', Icons.sentiment_very_dissatisfied, Colors.red, rating),
      ],
    );
  }

  Widget _buildStarIcon(int index, int rating) {
    return IconButton(
      icon: Icon(Icons.star, color: index <= rating ? Colors.yellow : Colors.grey),
      onPressed: () {
        setState(() {
          serviceRating = index;
        });
      },
    );
  }

  Widget _buildFaceIcon(String text, IconData icon, Color color, int rating) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 50, color: rating == icon.hashCode ? color : Colors.grey),
        ),
        SizedBox(height: 10),
        Text(text),
        Radio(
          value: icon.hashCode,
          groupValue: rating,
          onChanged: (value) {
            setState(() {
              foodRating = value as int;
            });
          },
        ),
      ],
    );
  }

  void _showThankYouPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank you. We appreciate your honest feedback'),
          content: ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text('OK'),
          ),
        );
      },
    );
  }

  void _showIncompleteRatingPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incomplete Rating'),
          content: Text('Please provide ratings for both service and food.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeedbackPage(),
  ));
}
