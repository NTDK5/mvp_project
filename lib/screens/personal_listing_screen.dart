import 'package:airbnb/components/job_listing_item.dart';
import 'package:airbnb/components/personal_job_listing_card.dart';
import 'package:airbnb/components/personal_rental_listing_card.dart';
import 'package:airbnb/components/rental_listing_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalListingView extends StatefulWidget {
  const PersonalListingView({super.key});

  @override
  State<PersonalListingView> createState() => _PersonalListingViewState();
}

class _PersonalListingViewState extends State<PersonalListingView> {
  late User _currentUser;
  late List<DocumentSnapshot> _rentalListings = [];
  late List<DocumentSnapshot> _JobListings = [];

  @override
  void initState() {
    super.initState(); // Load user name when the widget initializes
    _loadRentalListings(); // Load rental listings when the widget initializes
  }

  // Method to load rental listings from Firestore
  Future<void> _loadRentalListings() async {
    _currentUser = FirebaseAuth.instance.currentUser!;
    QuerySnapshot rentalSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .collection('listings')
        .where('type', isEqualTo: 'rent')
        .get();
    QuerySnapshot jobSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .collection('listings')
        .where('type', isEqualTo: 'job')
        .get();

    setState(() {
      _rentalListings = rentalSnapshot.docs;
      _JobListings = jobSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text('Rental'),
          SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _rentalListings.length,
            itemBuilder: (context, index) {
              // Extract listing data from document snapshot
              Map<String, dynamic> listingData =
                  _rentalListings[index].data() as Map<String, dynamic>;
              return PersonalRentalListingCard(
                listing: listingData,
              );
            },
          ),
          SizedBox(
            height: 30,
          ),
          Text("Job"),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _JobListings.length,
            itemBuilder: (context, index) {
              // Extract listing data from document snapshot
              Map<String, dynamic> listingData =
                  _JobListings[index].data() as Map<String, dynamic>;
              return PersonalJobListingCard(listing: listingData);
            },
          ),
        ],
      ),
    );
  }
}
