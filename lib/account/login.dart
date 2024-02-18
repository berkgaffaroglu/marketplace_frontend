import 'dart:convert';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import "csrf_handler.dart";
import 'session_handler.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    checkIfLoggedIn(); // Check if the user is already logged in when the widget initializes
  }

  void checkIfLoggedIn() async {
    var sessionToken = await getSessionToken();
    if (sessionToken != null && sessionToken != "") {
      // If session token exists, user is already logged in, navigate to another screen

      Navigator.pushReplacementNamed(context,
          '/listings'); // Replace '/home' with the route for your home screen
    }
  }

  Future<void> fetchData() async {
    setState(() {});
    Map<String, String> requestBody = <String, String>{
      'email': _usernameController.text,
      'password': _passwordController.text
    };

    var request =
        http.MultipartRequest('POST', Uri.parse('${SERVER_IP}/account/login/'))
          ..fields.addAll(requestBody);
    var response = await request.send();
    var headers = response.headers;
    var setCookieHeader = headers['set-cookie'];
    if (setCookieHeader != null) {
      // Split the Set-Cookie header by semicolons to separate individual cookie attributes
      String csrfToken = setCookieHeader.split(';')[0].split('=')[1];
      saveCSRFToken(csrfToken);
    }
    var respStr = await utf8.decodeStream(response.stream);
    var jsonResponse = jsonDecode(respStr);

    var authToken = await jsonResponse['session_id'];
    await saveSessionToken(authToken);
    checkIfLoggedIn();
  }

  void _login() {
    // Implement your login logic here
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Example: Validate the username and password
    if (username.isNotEmpty && password.isNotEmpty) {
      fetchData();
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
