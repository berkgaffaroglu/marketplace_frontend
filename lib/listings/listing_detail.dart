import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace_frontend/listings/create_listing.dart';
import 'package:marketplace_frontend/listings/update_listing.dart';
import 'listing_model.dart';
import "../account/csrf_handler.dart";
import "../account/session_handler.dart";
import '../constants.dart';
import '../account/logout.dart';

class ListingDetail extends StatefulWidget {
  final int id; // Declare id as a parameter

  const ListingDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ListingDetail> createState() => _ListingDetailState();
}

class _ListingDetailState extends State<ListingDetail> {
  Listing? _listing; // Define _listing as a nullable Listing object
  bool _isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http
        .get(Uri.parse('${SERVER_IP}/listings/listing-detail/${widget.id}'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      setState(() {
        _listing = Listing.fromJson(data); // Create the Listing object directly
        _isLoading = false;
      });
    } else {
      setState(() {
        _listing = null; // Clear the previous data if failed to fetch
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
      appBar: AppBar(
        title: Text(""),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () => fetchData(),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (_listing == null
                ? Center(
                    child: Text('No data available'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.network(
                            '${SERVER_IP}${_listing!.imageUrl}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${_listing!.title}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${_listing!.price.toString()} TL',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${_listing!.description}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdateListingPage(id: widget.id)),
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
