import 'dart:convert';
import 'package:flutter/services.dart'; // Import this package

import 'package:flutter/material.dart';
import '../constants.dart';
import 'listings.dart';
import 'package:http/http.dart' as http;
import "../account/csrf_handler.dart";
import "../account/session_handler.dart";

class CreateListingPage extends StatefulWidget {
  @override
  _CreateListingPageState createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    checkIfLoggedIn(); // Check if the user is already logged in when the widget initializes
  }

  Future<void> checkIfLoggedIn() async {
    var sessionToken = await getSessionToken();
    if (sessionToken != null && sessionToken != "") {
      print('OK');
    }
    // else {
    //   Navigator.pushReplacementNamed(context,
    //       '/login'); // Replace '/home' with the route for your home screen
    // }
  }

// make this return integer so it will redirect to the details of the created listing
  Future<void> createListing() async {
    setState(() {});
    Map<String, String> requestBody = <String, String>{
      'title': _titleController.text,
      'description': _descriptionController.text,
      'price': _priceController.text
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('${SERVER_IP}/listings/create-listing'))
      ..fields.addAll(requestBody);

    var sessionToken = await getSessionToken();
    var csrfToken = await getCSRFToken();

    Map<String, String> requestHeader = <String, String>{
      'Cookie': 'sessionid=${sessionToken};csrftoken=${csrfToken}',
      'X-Csrftoken': '${csrfToken}'
    };

    request.headers.addAll(requestHeader);

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    print(respStr);
  }

  void _create_listing() {
    // Implement your login logic here
    String title = _titleController.text;
    String description = _descriptionController.text;
    String priceText = _priceController.text;
    double? price = double.tryParse(priceText);
    // Example: Validate the username and password
    if (title.isNotEmpty &&
        description.isNotEmpty &&
        priceText.isNotEmpty &&
        price != null) {
      createListing();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Listings()),
      );
    } else {
      // Show an error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Email and password are required.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Listing'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              keyboardType:
                  TextInputType.number, // Ensure numeric keyboard is displayed
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ], // Allow only numeric input
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _create_listing,
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
