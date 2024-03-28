import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditListingScreen extends StatefulWidget {
  final Map<String, dynamic>?
      listingData; // Pass the listing data to the screen

  EditListingScreen({Key? key, required this.listingData}) : super(key: key);

  @override
  _EditListingScreenState createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _employmentTypeController =
      TextEditingController();
  final TextEditingController _companyInfoController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();

  String _type = 'rent'; // Default to 'rent'
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Populate the text controllers with listing data if available
    if (widget.listingData != null) {
      _populateTextControllers(widget.listingData!);
    }
  }

  void _populateTextControllers(Map<String, dynamic>? listingData) {
    if (listingData != null) {
      _titleController.text = listingData['title'] ?? '';
      _descriptionController.text = listingData['description'] ?? '';
      _locationController.text = listingData['location'] ?? '';
      _priceController.text =
          (listingData['price'] as double?)?.toString() ?? '';
      _contactInfoController.text = listingData['contactInfo'] ?? '';
      _employmentTypeController.text = listingData['employmentType'] ?? '';
      _companyInfoController.text = listingData['companyInfo'] ?? '';
      _deadlineController.text = listingData['deadline'] ?? '';
      _companyNameController.text = listingData['companyName'] ?? '';

      // Set the type to match the listing data
      setState(() {
        _type = listingData['type'] ?? 'rent';
      });
    }
  }

  Future<void> _editListing() async {
    try {
      // Access the text from controllers
      String title = _titleController.text;
      String description = _descriptionController.text;
      String location = _locationController.text;
      double price = double.tryParse(_priceController.text) ?? 0.0;
      String contactInfo = _contactInfoController.text;
      String employmentType = _employmentTypeController.text;
      String companyInfo = _companyInfoController.text;
      String deadline = _deadlineController.text;
      String companyName = _companyNameController.text;
      // Get the current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Upload the image file to Firebase Storage if it's for 'rent' type
      String? imageUrl;
      if (_type == 'rent' && _imageFile != null) {
        imageUrl = await _uploadImageToStorage(_imageFile!);
      }

      // Ensure listingData is not null before accessing its keys
      if (widget.listingData != null) {
        // Create a map representing the listing data
        Map<String, dynamic> listingData = {
          'title': title,
          'description': description,
          'type': _type,
          'location': location,
          if (_type == 'rent') 'price': price,
          if (_type == 'job') 'contactInfo': contactInfo,
          "employmentType": employmentType, "companyInfo": companyInfo,
          'companyName': companyName,
          "deadline": deadline,
          'createdAt': Timestamp.now(), // Use Firestore Timestamp for date/time
          'userId':
              uid, // Add the user's UID to associate the listing with the user
          if (_type == 'rent')
            'imageUrl': imageUrl, // Add the image URL if it's for 'rent' type
        };

        // Get the listing ID of the listing being edited
        String listing = widget.listingData!['listing'];

        // Update the listing data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('listings')
            .doc(listing)
            .update(listingData);

        await FirebaseFirestore.instance
            .collection('listings')
            .doc(listing)
            .update(listingData);

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Listing updated successfully'),
          ),
        );
      } else {
        // Handle the case where listingData is null
        throw Exception('Listing data is null');
      }
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating listing: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    try {
      // Upload the image file to Firebase Storage
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      await storageReference.putFile(imageFile);
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      throw Exception('Error uploading image: $error');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Listing'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField(
              value: _type,
              items: [
                DropdownMenuItem(
                  value: 'rent',
                  child: Text('Rental'),
                ),
                DropdownMenuItem(
                  value: 'job',
                  child: Text('Job Opportunity'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _type = value.toString();
                });
              },
            ),
            SizedBox(height: 10),
            if (_type == 'rent') ...[
              _imageFile != null
                  ? Image.file(_imageFile!)
                  : SizedBox(
                      height: 100,
                      child: Center(
                        child: Text('Upload your image here'),
                      ),
                    ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: _pickImage,
                child: Text(
                  'Upload Image',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            if (_type == 'job') ...[
              TextField(
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              TextField(
                controller: _companyInfoController,
                decoration: InputDecoration(
                  labelText: 'Company Info',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _contactInfoController,
                decoration: InputDecoration(
                  labelText: 'Contact Information',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _employmentTypeController,
                decoration: InputDecoration(
                  labelText: 'Employment Type',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _deadlineController,
                decoration: InputDecoration(
                  labelText: 'Deadline',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ],
            SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 10),
            if (_type == 'rent') ...[
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              onPressed: _editListing,
              child: Text(
                'Edit Listing',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
