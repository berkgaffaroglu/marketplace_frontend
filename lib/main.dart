import 'package:flutter/material.dart';
import 'package:marketplace_frontend/listings/create_listing.dart';
import 'package:marketplace_frontend/listings/update_listing.dart';
import 'listings/listings.dart';
import 'account/login.dart';
import 'account/logout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(), // Login route
        '/listings': (context) => Listings(), // Listings route
        '/create-listing': (context) => CreateListingPage(), // Listings route
        '/logout': (context) => LogoutPage(), // Listings route
        // Add more routes as needed
      },
    );
  }
}
