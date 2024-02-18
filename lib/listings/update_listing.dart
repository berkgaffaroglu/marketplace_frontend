import 'dart:convert';
import 'package:flutter/services.dart'; // Import this package
import 'package:marketplace_frontend/listings/listing_detail.dart';
import 'listing_model.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'listings.dart';
import 'package:http/http.dart' as http;
import "../account/csrf_handler.dart";
import "../account/session_handler.dart";

class UpdateListingPage extends StatefulWidget {
  final int id; // Declare id as a parameter
  const UpdateListingPage({Key? key, required this.id}) : super(key: key);
  @override
  State<UpdateListingPage> createState() => _UpdateListingPageState();
}

class _UpdateListingPageState extends State<UpdateListingPage> {
  bool _isLoading = false;
  Listing? _listing; // Define _listing as a nullable Listing object
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    checkIfLoggedIn(); // Check if the user is already logged in when the widget initializes
    fetchData();
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

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http
        .get(Uri.parse('${SERVER_IP}/listings/listing-detail/${widget.id}'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      _listing = Listing.fromJson(data); // Create the Listing object directly

      _titleController.value = TextEditingController.fromValue(
              TextEditingValue(text: "${_listing?.title}"))
          .value;
      _descriptionController.value = TextEditingController.fromValue(
              TextEditingValue(text: "${_listing?.description}"))
          .value;
      _priceController.value = TextEditingController.fromValue(
              TextEditingValue(text: "${_listing?.price}"))
          .value;
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _listing = null; // Clear the previous data if failed to fetch
        _isLoading = false;
      });
    }
  }

// make this return integer so it will redirect to the details of the created listing
  Future<void> updateListing() async {
    setState(() {});
    Map<String, String> requestBody = <String, String>{
      'title': _titleController.text,
      'description': _descriptionController.text,
      'price': _priceController.text
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('${SERVER_IP}/listings/edit-listing/${widget.id}'))
      ..fields.addAll(requestBody);
    var sessionToken = await getSessionToken();
    var csrfToken = await getCSRFToken();
    Map<String, String> requestHeader = <String, String>{
      'Cookie': 'sessionid=${sessionToken};csrftoken=${csrfToken}',
      'X-Csrftoken': '${csrfToken}'
    };
    request.headers.addAll(requestHeader);
    await request.send();
  }

  Future<void> deleteListing() async {
    setState(() {});

    var request = http.MultipartRequest(
        'POST', Uri.parse('${SERVER_IP}/listings/delete-listing/${widget.id}'));

    var sessionToken = await getSessionToken();
    var csrfToken = await getCSRFToken();

    Map<String, String> requestHeader = <String, String>{
      'Cookie': 'sessionid=${sessionToken};csrftoken=${csrfToken}',
      'X-Csrftoken': '${csrfToken}'
    };

    request.headers.addAll(requestHeader);

    await request.send();
  }

  void _delete_listing() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This listing will be deleted.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deleteListing();
                Navigator.of(context).pop();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Listings()),
                    (Route<dynamic> route) => false);
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _update_listing() {
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
      updateListing();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListingDetail(
                    id: widget.id,
                  )));
      // MaterialPageRoute(builder: (context) => ListingDetail(id: widget.id)),
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
          title: Text('Update Listing'),
        ),
        body: RefreshIndicator(
          color: Colors.black,
          onRefresh: () => fetchData(),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
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
                        keyboardType: TextInputType
                            .number, // Ensure numeric keyboard is displayed
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ], // Allow only numeric input
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _update_listing,
                        child: Text('Save'),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _delete_listing,
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
