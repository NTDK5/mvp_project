import 'package:airbnb/components/rental_listing_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RentalListingView extends StatefulWidget {
  const RentalListingView({Key? key}) : super(key: key);

  @override
  State<RentalListingView> createState() => _RentalListingViewState();
}

class _RentalListingViewState extends State<RentalListingView> {
  late List<DocumentSnapshot> _rentalListings = [];
  late List<DocumentSnapshot> _filteredRentalListings = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isTwoBedroomsSelected = false;
  bool _isThreeBedroomsSelected = false;
  bool _isAllSelected = true;

  @override
  void initState() {
    super.initState();
    _loadRentalListings();
  }

  Future<void> _loadRentalListings() async {
    QuerySnapshot rentalSnapshot = await FirebaseFirestore.instance
        .collection('listings')
        .where('type', isEqualTo: 'rent')
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

  void _applyFilters() async {
    // Apply filters based on selected options

    final QuerySnapshot rentalSnapshot =
        await FirebaseFirestore.instance.collection('listings').get();
    List<DocumentSnapshot> filteredListings = rentalSnapshot.docs;
    List<DocumentSnapshot> filteredListing;

    if (_isTwoBedroomsSelected) {
      filteredListing = filteredListings.where((listing) {
        // Check if listing has 2 bedrooms
        return (listing['bedrooms'] ?? 0) == 2;
      }).toList();
      setState(() {
        _rentalListings = filteredListing;
      });
    }

    if (_isThreeBedroomsSelected) {
      filteredListings = filteredListings.where((listing) {
        // Check if listing has 3 bedrooms
        return (listing['bedrooms'] ?? 0) == 3;
      }).toList();
      setState(() {
        _rentalListings = filteredListings;
      });
    }
    if (_isAllSelected) {
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
          TextField(
            controller: _searchController,
            onChanged: _filterRentalListings,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterButton(
                  text: '2 Bedrooms',
                  isSelected: _isTwoBedroomsSelected,
                  onPressed: () {
                    setState(() {
                      _isTwoBedroomsSelected = !_isTwoBedroomsSelected;
                      _applyFilters();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterButton(
                  text: '3 Bedrooms',
                  isSelected: _isThreeBedroomsSelected,
                  onPressed: () {
                    setState(() {
                      _isThreeBedroomsSelected = !_isThreeBedroomsSelected;
                      _applyFilters();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterButton(
                  text: 'All',
                  isSelected: _isThreeBedroomsSelected,
                  onPressed: () {
                    setState(() {
                      _isAllSelected = !_isAllSelected;
                      _applyFilters();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Rental Listings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _rentalListings.length,
              itemBuilder: (context, index) {
                // Extract listing data from document snapshot
                Map<String, dynamic> listingData =
                    _rentalListings[index].data() as Map<String, dynamic>;
                return RentalListingCard(
                  listing: listingData,
                );
              })
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
