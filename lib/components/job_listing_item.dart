import 'package:airbnb/screens/listing_detail_screen.dart';
import 'package:flutter/material.dart';

class JobListingCard extends StatelessWidget {
  final Map<String, dynamic> listing;

  const JobListingCard({Key? key, required this.listing}) : super(key: key);

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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
                        listing['title' ?? ""],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(listing['companyName' ?? ""])
                    ],
                  ),
                  Text(listing['employmentType'] ?? "")
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                slicedDescription,
                style: TextStyle(color: Colors.black54),
              )
            ],
          ),
        ),
      ),
    );
  }
}
