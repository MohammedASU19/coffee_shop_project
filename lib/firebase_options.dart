// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCItsz-lba8nYM7AtEs6XONNs7_iZoqtfY',
    appId: '1:109564943959:web:992edc273bf43ff8980d12',
    messagingSenderId: '109564943959',
    projectId: 'coffee-shop-project-c39b1',
    authDomain: 'coffee-shop-project-c39b1.firebaseapp.com',
    databaseURL: 'https://coffee-shop-project-c39b1-default-rtdb.firebaseio.com',
    storageBucket: 'coffee-shop-project-c39b1.appspot.com',
    measurementId: 'G-QSR45TCNHB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWnAIjNOXtuQTDep45VwJH-Y9LvcvbYbw',
    appId: '1:109564943959:android:1aa68bf31bdd36a4980d12',
    messagingSenderId: '109564943959',
    projectId: 'coffee-shop-project-c39b1',
    databaseURL: 'https://coffee-shop-project-c39b1-default-rtdb.firebaseio.com',
    storageBucket: 'coffee-shop-project-c39b1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPrps0m1GqUn_ER4vPr70fLgc7tLnug4w',
    appId: '1:109564943959:ios:c9722be190b0cac4980d12',
    messagingSenderId: '109564943959',
    projectId: 'coffee-shop-project-c39b1',
    databaseURL: 'https://coffee-shop-project-c39b1-default-rtdb.firebaseio.com',
    storageBucket: 'coffee-shop-project-c39b1.appspot.com',
    iosClientId: '109564943959-4hflde6h9r20r7gsciishp7dinofcgq1.apps.googleusercontent.com',
    iosBundleId: 'com.example.coffeeShopProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPrps0m1GqUn_ER4vPr70fLgc7tLnug4w',
    appId: '1:109564943959:ios:62456fccb255d01c980d12',
    messagingSenderId: '109564943959',
    projectId: 'coffee-shop-project-c39b1',
    databaseURL: 'https://coffee-shop-project-c39b1-default-rtdb.firebaseio.com',
    storageBucket: 'coffee-shop-project-c39b1.appspot.com',
    iosClientId: '109564943959-pr62qrvurdck4p94bg77im7ienjsvbea.apps.googleusercontent.com',
    iosBundleId: 'com.example.coffeeShopProject.RunnerTests',
  );
}