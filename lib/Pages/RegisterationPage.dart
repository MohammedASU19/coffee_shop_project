import 'dart:io';
import 'package:coffee_shop_project/Drawer/Drawer.dart';
import 'package:coffee_shop_project/Pages/LoginPage.dart';
import 'package:coffee_shop_project/Pages/Profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop_project/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  // Add this line to declare userProfile
  Map<String, dynamic>? userProfile;
//Using the Filepicker package, we can use the pickAnImage Function to upload a profile image from our platform 
FilePickerResult? _img;
File? _selectedImage;
Future<void> pickAnImage() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if (result != null) {
    setState(() {
      _img = result;
    });
  } else {
    print("No file selected");
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showRegistrationDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 8),
                      Text('Register now!'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 2,
                        height: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 2,
                        height: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showGoogleSignUpDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/Images/google_icon.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Sign up with Google',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showFacebookSignUpDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/Images/facebook_icon.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Sign up with Facebook',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _navigateToLoginPage,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRegistrationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Fill in your info to Register'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _img == null
                    ? IconButton(
                        onPressed: () {
                          pickAnImage();
                        },
                        icon: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: _selectedImage != null
                          ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              ),
                              )
                              : Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.blue,
                                ),
                                ),
                                )
                    : CircleAvatar(
                        radius: 25,
                        backgroundImage: MemoryImage(_img!.files.first.bytes!),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          icon: Icon(Icons.supervised_user_circle),
                          border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.length < 5) {
                              return 'Please enter a username';
                              }
                              return null;
                              },
                              ),
                SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      icon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      icon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.length != 9 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please enter a valid 9-digit phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 18),
                        lastDate: DateTime.now(),
                      );

                      if (date != null) {
                        _dobController.text = date.toLocal().toString().split(' ')[0];
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      icon: Icon(Icons.date_range),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  _showImagePopUp();
                  _handleSignUp();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
//Methon for Sign up in the Registration Page.
Future<void> _handleSignUp() async {
  UploadTask uploadTask = profileimageref.putData(_img!.files.first.bytes!);
  String imgurl = await (await uploadTask).ref.getDownloadURL();

  Auth().createUserWithEmailAndPassword(
    email: _usernameController.text,
    password: _passwordController.text,
    username: _usernameController.text,
    phoneNumber: _phoneNumberController.text,
    dob: _dobController.text,
    profilePhoto: imgurl, // Pass the imgurl to createUserWithEmailAndPassword
  ).then((_) {
    // After successful registration, show the image popup
    _showImagePopUp();
  });
}


void _showImagePopUp() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Image.asset(
          'lib/Images/Signup.gif',
          width: 170,
          height: 170,
        ),
      );
    },
  );

  // Close the pop-up after a delay (e.g., 6 seconds)
  Future.delayed(Duration(seconds: 6), () {
    Navigator.of(context).pop(); // Remove this line from here

    // Check if the current route is the RegistrationPage
    if (ModalRoute.of(context)!.settings.name == RegistrationPage().toString()) {
      // If so, navigate to the ProfilePage
      _loadUserProfileAndNavigate();
    }
  });
}


  void _loadUserProfileAndNavigate() async {
    await _loadUserProfile();
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  void _showGoogleSignUpDialog() {
    // Your Google sign-up logic here
  }

  void _showFacebookSignUpDialog() {
    // Your Facebook sign-up logic here
  }

  void _navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

Future <void> _loadUserProfile() async {
  final User? user = Auth().currentUser;

  if (user != null) {
    try {
      DataSnapshot snapshot = (await userRef.child(user.uid).once()) as DataSnapshot;
      Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;

      setState(() {
        userProfile = data;
      });
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }
}



}
