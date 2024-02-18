import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCSRFToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('csrf_token', token);
}

Future<String?> getCSRFToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('csrf_token');
}

Future<void> clearCSRFToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('csrf_token', "");
}
