import 'package:airbnb/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final UserService _userService = UserService();
  late String _userName = '';
  late String _email = '';
  late Future<Map<String, dynamic>?> _userDocument;

  Future<void> _loadUserData() async {
    _userDocument = _userService.getUserData();
    Map<String, dynamic>? userData = await _userDocument;
    if (userData != null) {
      setState(() {
        _userName = userData['username'];
        _email = userData['email'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20.0),
          child: Text('Profile'),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Icon(
                    Icons.account_circle_rounded,
                    color: Colors.grey[700],
                    size: 100,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _userName,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  _email,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: screenWidth, // Set width to match the screen width
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 2.0,
                          color: Colors.black54,
                        ), // Top border
                        bottom: BorderSide(
                          width: 2.0,
                          color: Colors.black54,
                        ), // Bottom border
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 10),
                                    Text('Edit Profile'),
                                  ],
                                ),
                                Icon(Icons.arrow_right),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.lock),
                                    SizedBox(width: 10),
                                    Text('Change Password'),
                                  ],
                                ),
                                Icon(Icons.arrow_right),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.settings),
                                    SizedBox(width: 10),
                                    Text('Settings'),
                                  ],
                                ),
                                Icon(Icons.arrow_right),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black54, width: 2))),
                    width: screenWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.help),
                                  SizedBox(width: 10),
                                  Text('Help & Supports'),
                                ],
                              ),
                              Icon(Icons.arrow_right),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                await FirebaseAuth.instance.signOut();
                                // Navigate to login or another appropriate screen after logout
                                Navigator.of(context)
                                    .pushReplacementNamed('/login/');
                              } catch (e) {
                                print('Error signing out: $e');
                                // Handle sign-out errors
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.logout),
                                    SizedBox(width: 10),
                                    Text('Logout'),
                                  ],
                                ),
                                Icon(Icons.arrow_right),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
