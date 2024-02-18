import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace_frontend/listings/create_listing.dart';
import 'package:marketplace_frontend/listings/update_listing.dart';
import 'listing_model.dart';
import 'listing_detail.dart';
import "../account/csrf_handler.dart";
import "../account/session_handler.dart";
import '../constants.dart';
import '../account/logout.dart';

class Listings extends StatefulWidget {
  const Listings({Key? key}) : super(key: key);

  @override
  State<Listings> createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  List<Listing> _listings = [];
  bool _isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await http.get(Uri.parse('${SERVER_IP}/listings/query-listings'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        _listings = data.map((item) => Listing.fromJson(item)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _listings = []; // Clear the previous data if failed to fetch
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () => fetchData(),
        // onRefresh: () =>
        //     Navigator.pushReplacementNamed(context, '/create-listing'),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (_listings.isEmpty
                ? Center(
                    child: Text('No data available'),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 0.75 // Aspect ratio of items
                        ),
                    itemCount: _listings.length,
                    itemBuilder: (context, index) {
                      final listing = _listings[index];
                      int listingId = listing.id;
                      return GestureDetector(
                          onTap: () {
                            // Add your onTap logic here
                            // For example, navigate to the detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListingDetail(id: listingId)),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        5.0), // Add padding here
                                    child: Image.network(
                                      '${SERVER_IP}${listing.imageUrl}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20),
                                  child: Text(
                                    '${listing.title}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, bottom: 20, left: 20),
                                  child: Text(
                                    '${listing.price.toString()} TL',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateListingPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
