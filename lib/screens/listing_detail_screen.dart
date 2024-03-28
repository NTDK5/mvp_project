import 'package:flutter/material.dart';

class RentalDetailView extends StatelessWidget {
  final Map<String, dynamic> listing;
  const RentalDetailView({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Set app bar background color to transparent
        elevation: 0, // Remove app bar shadow
      ),
      body: Stack(
        children: [
          // Image widget positioned to take more height
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height *
                0.4, // Adjust the height as needed
            child: Image.network(
              listing['imageUrl'],
              fit: BoxFit.cover,
            ),
          ),
          // Container to add padding to the body content
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height *
                    0.4), // Margin to position content below the image
            padding: EdgeInsets.all(
                8), // Adjust padding to position content below app bar
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Your body content here
                    // Example content
                    Container(
                      color: Colors.white, // Example content background color
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            listing['title'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [Icon(Icons.star), Text('4.5')],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(listing['location']),
                        Text(','),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          listing['price'].toString(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Text(listing[
                        'description']) // Add spacing between the content and the bottom of the screen
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JobDetailView extends StatelessWidget {
  final Map<String, dynamic> listing;
  const JobDetailView({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.transparent, // Set app bar background color to transparent
          elevation: 0, // Remove app bar shadow
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      Text(
                        listing['title'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      Text(listing['companyName'])
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Employment Type'),
                        Text(listing['employmentType'])
                      ],
                    ),
                    Column(
                      children: [
                        Text('Employment Type'),
                        Text(listing['employmentType'])
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Description',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(listing['description'])
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Overview',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(listing['companyInfo'])
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Location:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(listing['location']),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Deadline',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(listing['deadline']),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Contact Info',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(listing['contactInfo']),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
