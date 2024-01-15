import 'package:flutter/material.dart';
import 'package:coffee_shop_project/Drawer/Drawer.dart';
import 'package:coffee_shop_project/Pages/LoginPage.dart';
import 'package:coffee_shop_project/Pages/RegisterationPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; //Authentication for User details for SignIn/SignUp
import 'package:coffee_shop_project/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart'; //Firebase Database using Realtime Database to store User details
import 'package:firebase_storage/firebase_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

final DatabaseReference userRef = FirebaseDatabase.instance.reference().child("users");

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }
Future<void> createUserWithEmailAndPassword({
  required String email,
  required String password,
  required String username,
  required String phoneNumber,
  required String dob, 
  required String profilePhoto,
}) async {
  await auth.createUserWithEmailAndPassword(email: email, password: password);
  await storeUserProfile(
    userId: auth.currentUser!.uid,
    username: username,
    phoneNumber: phoneNumber,
    dob: dob,
    profilePhoto: profilePhoto,
  );
}


  Future<void> storeUserProfile({
    required String userId,
    required String username,
    required String phoneNumber,
    required String dob, 
    required String profilePhoto,
  }) async {
    // Map<dynamic, dynamic> user = {
    //   "username": username,
    //   "phoneNumber": phoneNumber,
    //   "dob": dob,
    // };

    UserDetails user= UserDetails(
      username: username, 
      phoneNumber: phoneNumber, 
      profilePhoto: "https://images.squarespace-cdn.com/content/v1/62fa6702960a0d5904f50931/1660632509885-XG3FM478SFZRS5IJJAT8/man5-5121580819489.png", 
      email: username,
      dob: dob,
      );

    userRef.child(userId).set(user.toMap()).then((value) {
      print("User added successfully to realtime database");
    }).catchError((error) {
      print("Failed to add user to realtime database");
      print(error.toString());
    });
  }
  
  Future<Map<String, dynamic>?> getUserProfile() async {
  final User? user = auth.currentUser;

  if (user != null) {
    try {
      DataSnapshot snapshot = (await userRef.child(user.uid).once()) as DataSnapshot;
      Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?; 
      return data;
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  return null;
}





  Future<void> signOut() async {
    await auth.signOut();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData( 
        scaffoldBackgroundColor: Color.fromRGBO(251, 242, 231, 1),
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
            Icon(Icons.coffee),
            SizedBox(width: 8),
            Text('MHS Coffee Shop'),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
              'lib/Images/mhs_logo.png',
              width: 300,
              height: 300, 
            ),
              SizedBox(height: 20),
              Text(
                'Thirsty for Coffee? Welcome to our shop!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }
}

class UserDetails{
  String username;
  String email;
  String phoneNumber;
  String profilePhoto;
  String dob;
//This make it so the User is required to input these details
  UserDetails({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePhoto,
    required this.dob,
  });
  //convert UserDetails object to a Map
  Map<dynamic, dynamic> toMap(){
    return{
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePhoto': profilePhoto,
      'dob': dob,
    };}

    //Create a UserDetails object from a map
    factory UserDetails.fromMap(Map<dynamic, dynamic> map){
      return UserDetails(
        username: map['username'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        profilePhoto: map['profilePhoto'],
        dob: map['dob'],
      );
    }
}

//TO STORE THE USER PROFILE PICTURE IN FIREBASE STORAGE
final Reference profileimageref = FirebaseStorage.instance.ref().child(
  "UserProfileImage/${DateTime.now().millisecondsSinceEpoch}.jpg"
);



//a Class to retrive User Information. The current user information
class FirebaseService{
  User? user=Auth().auth.currentUser;
  DatabaseReference userref= FirebaseDatabase.instance.ref().child("users");
  Future<UserDetails?> getUserFromDatabase() async{
    try{
          if(user != null){
      DatabaseEvent event= await userref.child(user!.uid).once();
      if(event.snapshot.value != null){
        Map<dynamic, dynamic> snapMap = event.snapshot.value as dynamic;
        return UserDetails.fromMap(snapMap);
      }else{
        print("User details is null");
        return null;
      }
    }else{
      print("the current user is null");
      return null;
    }
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}
