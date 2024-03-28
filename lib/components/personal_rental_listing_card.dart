import 'package:airbnb/screens/edit_Listing_screen.dart';
import 'package:airbnb/screens/listing_detail_screen.dart';
import 'package:airbnb/screens/create_listing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonalRentalListingCard extends StatelessWidget {
  final Map<String, dynamic> listing;

  const PersonalRentalListingCard({Key? key, required this.listing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to individual listing page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentalDetailView(listing: listing),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                listing['title'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    listing['location'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  Text(
                    listing['price'].toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Add your onPressed function here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditListingScreen(listingData: listing),
                          ),
                        );
                      },
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(8)),
                      color: Colors.red,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        // Add your onPressed function here

                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('listings')
                            .doc(listing['listing'])
                            .delete();
                        await FirebaseFirestore.instance
                            .collection('listings')
                            .doc(listing['listing'])
                            .delete();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
