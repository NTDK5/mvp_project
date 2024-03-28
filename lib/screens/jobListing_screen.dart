import 'package:airbnb/components/job_listing_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobListingView extends StatefulWidget {
  const JobListingView({Key? key}) : super(key: key);

  @override
  State<JobListingView> createState() => _JobListingViewState();
}

class _JobListingViewState extends State<JobListingView> {
  // Initialize user name with an empty string
  late List<DocumentSnapshot> _rentalListings = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState(); // Load user name when the widget initializes
    _loadRentalListings(); // Load rental listings when the widget initializes
  }

  // Method to load rental listings from Firestore
  Future<void> _loadRentalListings() async {
    QuerySnapshot rentalSnapshot = await FirebaseFirestore.instance
        .collection('listings')
        .where('type', isEqualTo: 'job')
        .get();

    setState(() {
      _rentalListings = rentalSnapshot.docs;
    });
  }

  void _filterRentalListings(String searchText) async {
    if (searchText.isNotEmpty) {
      final QuerySnapshot rentalSnapshot = await FirebaseFirestore.instance
          .collection('listings')
          .where('title', isGreaterThanOrEqualTo: searchText)
          .where('title', isLessThanOrEqualTo: searchText + '\uf8ff')
          .get();

      setState(() {
        _rentalListings = rentalSnapshot.docs;
      });
    } else {
      _loadRentalListings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar (Replace with your custom search bar widget)
          TextField(
            onChanged: _filterRentalListings,
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 20),
          // Filters Section (Replace with your custom filters widget)
          Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Job Listings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          // Rental Listings (Replace with your listing widgets)
          // Example:
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _rentalListings.length,
            itemBuilder: (context, index) {
              // Extract listing data from document snapshot
              Map<String, dynamic> listingData =
                  _rentalListings[index].data() as Map<String, dynamic>;
              return JobListingCard(listing: listingData);
            },
          ),
        ],
      ),
    );
  }
}
