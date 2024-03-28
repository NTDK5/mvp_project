import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ListingCreationScreen extends StatefulWidget {
  @override
  _ListingCreationScreenState createState() => _ListingCreationScreenState();
}

class _ListingCreationScreenState extends State<ListingCreationScreen> {
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
  final TextEditingController _bedroomsController = TextEditingController();
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();

  String _type = 'rent'; // Default to 'rent'
  File? _imageFile;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _contactInfoController.dispose();
    _employmentTypeController.dispose();
    _companyInfoController.dispose();
    _deadlineController.dispose();
    _companyNameController.dispose();
    _bedroomsController.dispose();
    super.dispose();
  }

  Future<void> _createListing() async {
    setState(() {
      _isloading = true;
    });
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
      double bedrooms = double.tryParse(_bedroomsController.text) ?? 0.0;
      // Get the current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Upload the image file to Firebase Storage if it's for 'rent' type
      String? imageUrl;
      if (_type == 'rent' && _imageFile != null) {
        imageUrl = await _uploadImageToStorage(_imageFile!);
      }

      // Generate a listing ID
      String listingId =
          FirebaseFirestore.instance.collection('listings').doc().id;

      // Create a map representing the listing data
      Map<String, dynamic> listingData = {
        'listing': listingId,
        'title': title,
        'description': description,
        'type': _type,
        'location': location,
        if (_type == 'rent') 'price': price, "bedrooms": bedrooms,
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

      // Add the listing data to Firestore under the user's subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('listings')
          .doc(listingId) // Use the generated listing ID as the document name
          .set(listingData);

      // Also, add the listing to the top-level 'listings' collection
      await FirebaseFirestore.instance
          .collection('listings')
          .doc(listingId) // Use the generated listing ID as the document name
          .set(listingData);
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _priceController.clear();
      _contactInfoController.clear();
      _employmentTypeController.clear();
      _companyInfoController.clear();
      _deadlineController.clear();
      _companyNameController.clear();
      _bedroomsController.clear();
      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Listing created successfully'),
      ));
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error creating listing: $error'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isloading = false;
      });
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
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
                        child: Text('upload your image here'),
                      ), // Placeholder for Image preview
                    ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  _pickImage();
                },
                child: Text(
                  'Upload Image',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              TextFormField(
                controller: _bedroomsController,
                decoration: InputDecoration(
                    labelText: 'Bedrooms',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    )),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bedrooms is required';
                  }
                  return null;
                },
              ),
            ],
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            if (_type == 'job') ...[
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(
                    labelText: 'Company Name',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'company Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companyInfoController,
                decoration: InputDecoration(
                    labelText: 'Company Info',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company Info is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contactInfoController,
                decoration: InputDecoration(
                  labelText: 'Contact Information',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Contact is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _employmentTypeController,
                decoration: InputDecoration(
                    labelText: 'Employment Type',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Employment Type is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(
                    labelText: 'Deadline',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deadline is required';
                  }
                  return null;
                },
              ),
            ],
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Location is required';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            if (_type == 'rent') ...[
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }
                  return null;
                },
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              onPressed: _isloading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _createListing();
                      }
                    },
              child: Text(
                'Create Listing',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
