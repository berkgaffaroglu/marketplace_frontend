import 'csrf_handler.dart';
import 'session_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  void initState() {
    super.initState();
    logout(context);
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
          children: <Widget>[],
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  final response = await http.post(Uri.parse('${SERVER_IP}/account/logout/'));
  if (response.statusCode == 200) {
    clearCSRFToken();
    clearSessionToken();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
