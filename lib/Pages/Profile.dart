import 'package:coffee_shop_project/Drawer/Drawer.dart';
import 'package:coffee_shop_project/Pages/ItemDetails.dart';
import 'package:coffee_shop_project/Pages/LoginPage.dart';
import 'package:coffee_shop_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService fbs= FirebaseService();
  UserDetails? usr;
  // @override 
  // void initState(){
  //   super.initState();
  //   if(Auth().auth.currentUser != null){
  //     fatchUserData();

  //   }
  // }

  Future <void> fatchUserData() async{
    try{
      UserDetails? us = await fbs.getUserFromDatabase();
      if (us !=null){
        setState((){
          usr = us;
        });
      }else{
        print("User not found");
      }
    }catch (e){
      print(e.toString());
    }
  }


  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    if(Auth().auth.currentUser != null){
      print("here.........${Auth().auth.currentUser != null}");
      fatchUserData();

    }
  }

void _loadUserProfile() async {
  final User? user = Auth().currentUser;

  if (user != null) {
    try {
      DatabaseEvent event = await userRef.child(user.uid).once();
      DataSnapshot snapshot = event.snapshot;

      Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;

      setState(() {
        userProfile = data;
      });
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }
}


  @override
  Widget build(BuildContext context) {
    if (usr != null){
      return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: Image.asset('lib/Images/Profile.gif', width: 200, height: 200),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userProfile != null)
                        Text(
                          'Username: ${userProfile!['username']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      SizedBox(height: 10),
                      if (userProfile != null)
                        Text(
                          'Phone Number: ${userProfile!['phoneNumber']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      SizedBox(height: 10),
                      if (userProfile != null)
                        Text(
                          'Date of Birth: ${userProfile!['dob']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemDetailPage()),
                  );
                },
                child: Text('Hungry? Order now!'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signOutAndShowDialog(context);
                },
                child: Text('Sign Out')
              ),
            ],
          ),
        ),
      ),
    );
    }else{
      return const Center(child: CircularProgressIndicator());
    }
  }

void _signOutAndShowDialog(BuildContext context) async {
  await Auth().signOut();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Signed out!'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your account has been signed out successfully.'),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Please click ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'here',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to the login page when the link is clicked
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                  ),
                  TextSpan(text: ' to Login.'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: TextStyle(color: const Color.fromARGB(255, 248, 73, 73))),
          ),
        ],
      );
    },
  );
}


}