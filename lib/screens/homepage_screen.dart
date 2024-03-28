import 'package:airbnb/screens/jobListing_screen.dart';
import 'package:airbnb/screens/personal_listing_screen.dart';
import 'package:airbnb/screens/rental_listing_screen.dart';
import 'package:airbnb/screens/create_listing_screen.dart';
import 'package:airbnb/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home_view extends StatefulWidget {
  @override
  _Home_viewState createState() => _Home_viewState();
}

class _Home_viewState extends State<Home_view> {
  late String _userName = '';
  final UserService _userService = UserService();
  late Future<Map<String, dynamic>?> _userDocument;

  Future<void> _loadUserData() async {
    _userDocument = _userService.getUserData();
    Map<String, dynamic>? userData = await _userDocument;
    if (userData != null) {
      setState(() {
        _userName = userData['username'];
      });
    }
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    RentalListingView(),
    JobListingView(),
    ListingCreationScreen(),
    PersonalListingView()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Rental'),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: 'Create'),
            BottomNavigationBarItem(
                icon: Icon(Icons.view_list), label: 'My Listings'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedIconTheme: IconThemeData(color: Colors.black),
          onTap: _onItemTapped,
        ),
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $_userName!', // Display greeting with user name
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Location: [User Location]', // Replace [User Location] with user's actual location
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.account_circle), // User profile icon
                onPressed: () {
                  Navigator.of(context).pushNamed('/user_profile/');
                },
              ),
            ],
          ),
        ),
        body: Container(child: _widgetOptions.elementAt(_selectedIndex)));
  }
}
