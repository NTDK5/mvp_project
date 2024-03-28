import 'package:airbnb/screens/homepage_screen.dart';
import 'package:airbnb/screens/welcome_screen.dart';
import 'package:airbnb/services/auth_service.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:airbnb/firebase_options.dart";
import 'package:firebase_core/firebase_core.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final UserService _userService = UserService();
  bool _isLoading = false;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 40,
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
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        final email = _email.text;
                                        final password = _password.text;
                                        try {
                                          final User? user = await _userService
                                              .signInWithEmailAndPassword(
                                                  email, password);
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
                                          if (e.code == 'invalid-credential') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Error signing In: User not found'),
                                              backgroundColor: Colors.red,
                                            ));
                                            print('user not found');
                                          } else if (e.code ==
                                              'wrong-password') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Error signing In: Wrong password'),
                                              backgroundColor: Colors.red,
                                            ));
                                            print('Wrong password');
                                          }
                                        } finally {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/register/', (route) => false);
                              },
                              child: const Text(
                                "Don't have account?sign up Now",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      ),
                    ),
                  );
                default:
                  return const Text('Loading...');
              }
            }));
  }
}
