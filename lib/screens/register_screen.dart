import 'package:airbnb/screens/homepage_screen.dart';
import 'package:airbnb/screens/welcome_screen.dart';
import 'package:airbnb/screens/login_screen.dart';
import 'package:airbnb/services/auth_service.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:airbnb/firebase_options.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final UserService _userService = UserService();
  bool _isLoading = false;

  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                // TODO: Handle this case.
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign UP',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          controller: _username,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Colors.black,
                            hintText: "Username",
                          ),
                        ),
                        TextField(
                          controller: _email,
                          enableSuggestions: true,
                          autocorrect: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            prefixIconColor: Colors.black,
                            hintText: "Email",
                          ),
                        ),
                        TextField(
                            controller: _password,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              prefixIconColor: Colors.black,
                              hintText: "Password",
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    final username = _username.text;
                                    final email = _email.text;
                                    final password = _password.text;
                                    try {
                                      bool _isLoading = false;

                                      final User? user = await _userService
                                          .signUpWithEmailAndPassword(
                                              email, password, username);
                                      if (user != null) {
                                        print(
                                            'Signed in successfully: ${user.uid}');
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home_view()));
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Error signing up: Weak password'),
                                          backgroundColor: Colors.red,
                                        ));
                                        print('Weak_password');
                                      } else if (e.code ==
                                          'email-already-in-use') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Error signing up:Email already in use '),
                                          backgroundColor: Colors.red,
                                        ));
                                        print('Email already in use');
                                      } else if (e.code == 'invalid-email') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Error siging up: Invalid email'),
                                          backgroundColor: Colors.red,
                                        ));
                                        print('Invalid Email');
                                      } else if (e.code ==
                                          "network-request-failed") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Error siging up: Network Error, please try again later'),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login/', (route) => false);
                            },
                            child: const Text(
                              'Already Registered? Login Now',
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    ),
                  ),
                );
              default:
                return const Text('Loading...');
            }
          }),
    );
  }
}
