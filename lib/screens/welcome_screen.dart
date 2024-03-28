import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Set up authentication state listener
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && user.emailVerified) {
        // User is logged in and email is verified
        // Proceed to navigate to the home page or perform other actions
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Opacity(
              opacity: 0.75,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Heading
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 110,
                    ),
                    Text(
                      'Discover a World of Opportunity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '1200! Lodgings to Get and Redeem You Points.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 200),
                // Buttons
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 15)),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/register/', (route) => false);
                          },
                          child: const Text(
                            'Join',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 15)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login/');
                          },
                          child: const Text('Sign In',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
