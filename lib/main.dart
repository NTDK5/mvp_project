import 'package:airbnb/firebase_options.dart';
import 'package:airbnb/screens/welcome_screen.dart';
import 'package:airbnb/screens/create_listing_screen.dart';
import 'package:airbnb/screens/login_screen.dart';
import 'package:airbnb/screens/register_screen.dart';
import 'package:airbnb/screens/homepage_screen.dart';
import 'package:airbnb/screens/user_profile_screen.dart';
import 'package:airbnb/screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black, // Set cursor color to black
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: const FirstPage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/verifyemail': (context) => const VerifyEmailView(),
        '/create_listings/': (context) => ListingCreationScreen(),
        '/rental_listings/': (context) => Home_view(),
        '/user_profile/': (context) => const UserProfileView(),
      },
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error initializing Firebase');
        } else {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            if (user.emailVerified) {
              print('You are a verified user');
              return Home_view();
            } else {
              return Home_view();
            }
          } else {
            return HomePage();
          }
        }
      },
    );
  }
}
