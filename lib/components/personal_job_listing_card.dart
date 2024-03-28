import 'package:airbnb/screens/edit_Listing_screen.dart';
import 'package:airbnb/screens/listing_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalJobListingCard extends StatelessWidget {
  final Map<String, dynamic> listing;

  const PersonalJobListingCard({Key? key, required this.listing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String description = listing['description'] ?? "";
    String slicedDescription =
        description.length > 100 ? description.substring(0, 100) : description;
    return GestureDetector(
      onTap: () {
        // Navigate to individual listing page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailView(listing: listing),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      listing['title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(listing['companyName'])
                  ],
                ),
                Text(listing['employmentType'])
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              slicedDescription,
              style: TextStyle(color: Colors.black54),
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
